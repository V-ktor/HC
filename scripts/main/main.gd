extends Node2D

var num_players := 2
var cpu := []
var max_cpu := []
var programs := []
var points := []
var colors := []
var player_type := []
var time := 0.0
var active := false
var started := false
var last_mouse_pos := Vector2(0,0)
var tm := 0.0
var gamestate
var root_nodes := [[],[]]
var victory_on_root_capture := false

var node_selected := -1

var action_button := preload("res://scenes/gui/action_button.tscn")
var effect_tooltip := preload("res://scenes/gui/effect_tooltip.tscn")
var click_particle := preload("res://scenes/particles/click.tscn")
var pulse_particle := preload("res://scenes/particles/pulse.tscn")
var connection_particle := preload("res://scenes/particles/connection.tscn")
var fire_wall_particle := preload("res://scenes/particles/fire.tscn")
var disrupt_particle := preload("res://scenes/particles/disrupt.tscn")

# When the timer reaches zero.
signal timeout(winner)


class ControlPoint:
	# Control points that can be captured by players.
	var position := Vector2()
	var connections := []
	var control := []
	var shield := []
	var max_shield := []
	var programs := []
	var used := []
	var ID := 0
	var slowdown := 0.0
	var gamestate
	var owner
	var node
	var particle_capture := preload("res://scenes/particles/capture.tscn")
	var mask := preload("res://scenes/particles/mask.tscn")
	var mask_dmg := 0.0
	
	func _init(_ID,num_players,pos,con,nd,_gamestate,_owner=-1):
		ID = _ID
		position = pos
		connections = con
		gamestate = _gamestate
		control.resize(num_players)
		shield.resize(num_players)
		max_shield.resize(num_players)
		for i in range(control.size()):
			control[i] = 0.0
			shield[i] = 0.0
			max_shield[i] = 0.0
		owner = _owner
		if owner>=0:
			control[owner] = 100.0
		node = nd
		used.resize(4)
		for i in range(4):
			used[i] = false
		check_owner()
	
	func has_access(player):
		# Can the player install his programs here?
		return player==owner
	
	func check_owner():
		var new_owner := -1
		var max_value := 50
		if owner>=0:
			max_value = control[owner]
			if max_value>=50:
				new_owner = owner
		for i in range(control.size()):
			if control[i]>max_value:
				new_owner = i
		if owner!=new_owner && Options.show_particles:
			var pi = particle_capture.instance()
			var mi = mask.instance()
			if new_owner>=0:
				pi.modulate = gamestate.colors[new_owner]
			mi.energy = 10
			node.add_child(pi)
			node.add_child(mi)
		owner = new_owner
		if owner>=0:
			node.get_node("Sprite").modulate = gamestate.colors[owner]
		else:
			node.get_node("Sprite").modulate = Color(1.0,1.0,1.0)
		check_programs()
	
	func check_programs():
		# Remove invalid programs.
		for program in programs:
			if program.owner!=owner:
				remove_program(program)
	
	func attack(player,amount):
		# Attack this control point.
		var dam = amount
		for i in range(0,player-1)+range(player+1,control.size()):
			if shield[i]>0.0:
				shield[i] -= dam
				if shield[i]<0.0:
					dam = -shield[i]
					shield[i] = 0.0
				else:
					dam = 0
					break
		for i in range(0,player-1)+range(player+1,control.size()):
			control[i] = max(control[i]-dam,0)
		control[player] = min(control[player]+dam,100)
		check_owner()
		
		if mask_dmg<amount && Options.show_particles:
			var mi = mask.instance()
			mi.energy = (amount+mask_dmg)/100.0
			node.add_child(mi)
			mask_dmg += 25-amount
		else:
			mask_dmg -= amount
	
	func defend(player,amount):
		# Add protection against attacks.
		shield[player] += amount
		max_shield[player] += amount
		
		if mask_dmg<amount && Options.show_particles:
			var mi = mask.instance()
			mi.energy = (amount+mask_dmg)/100.0
			node.add_child(mi)
			mask_dmg += 25-amount
		else:
			mask_dmg -= amount
	
	func cancel_defense(player,amount):
		# Cancel the protection.
		shield[player] -= amount*shield[player]/max(max_shield[player],1)
		max_shield[player] -= amount
	
	func add_program(program):
		for i in range(used.size()):
			if !used[i]:
				program.index = i
				programs.push_back(program)
				used[i] = true
				return i
		return -1
	
	func remove_program(program):
		program.remove()
		used[program.index] = false
		programs.erase(program)

class Program:
	# Programs running on control points.
	var type := ""
	var prgm
	var nodes := {}
	var owner := -1
	var cpu : int
	var delay : float
	var focus : Vector2
	var last : Vector2
	var gamestate
	var targets := []
	var current_command
	var stack := {}
	var ID := -1
	var index := -1
	var node
	var particles := []
	var tooltip
	var status_delay := 0.0
	var ticks := 0
	
	func _init(_type,_prgm,_player,_ID,_gamestate,_node):
		type = _type
		owner = _player
		ID = _ID
		targets = []
		prgm = _prgm
		nodes = prgm.nodes
		cpu = 0
		gamestate = _gamestate
		delay = 0.1
		for p in nodes.keys():
			if nodes[p].type=="initialize":
				focus = p
				break
		last = focus
		node = _node
		node.get_node("VBoxContainer/Status/HBoxContainer/Label").text = tr("INITIALIZE")
		node.get_node("VBoxContainer/Status").max_value = delay
		node.get_node("Icon").set_texture(load(prgm.icon))
		node.get_node("Code").text = "\n"+tr("INITIALIZE_LINE"+str((randi()%5)+1))+"\n"+tr("INITIALIZE_LINE"+str((randi()%5)+1))
	
	func remove():
		gamestate.cpu[owner] += cpu
		cpu = 0
		delay = 0.0
		if stack.has("pos") && stack[focus].command=="disrupt":
			var array = stack[focus].args
			if array.size()>0:
				if targets.size()>0:
					var effect = array[0]/100.0/targets.size()
					for target in targets:
						gamestate.nodes[target].slowdown -= effect
		node.get_node("VBoxContainer/Status").value = 0
		node.get_node("VBoxContainer/Duration").text = tr("REMAINING_TIME")%0.0
		node.get_node("VBoxContainer/Status/HBoxContainer/Label").text = tr("TERMINATE")
		node.get_node("AnimationPlayer").play("delete")
		for s in stack.values():
			for p in s.particles:
				p.timeout()
		gamestate.nodes[ID].programs.erase(self)
	
# warning-ignore:shadowed_variable
	func clear_command(line):
		if !stack.has(line):
			return
		
		for p in stack[line].particles:
			p.timeout()
		gamestate.cpu[owner] += stack[line].cpu
		cpu -= stack[line].cpu
		stack.erase(line)
	
	func finish_action(pos,failed=false):
		var current = nodes[pos]
		for i in range(stack.size()-1,-1,-1):
			var p = stack.keys()[i]
			if typeof(stack[p].sustained)==TYPE_STRING && stack[p].sustained==current.type:
				clear_command(p)
				break
		if !stack.has(pos):
			return
		var cmd = stack[pos].command
		if !stack[pos].sustained && !failed:
			if cmd=="attack":
				var array = stack[pos].args
				if array.size()>0:
					if targets.size()>0:
						var dam = array[0]/targets.size()
						for target in targets:
							gamestate.nodes[target].attack(owner,10*dam)
			elif cmd=="protect":
				var array = stack[pos].args
				if array.size()>0:
					if targets.size()>0:
						var dam = 0.5*array[0]/targets.size()
						for target in targets:
							gamestate.nodes[target].cancel_defense(owner,10*dam)
			elif cmd=="disrupt":
				var array = stack[pos].args
				if array.size()>0:
					if targets.size()>0:
						var effect = array[0]/100.0/targets.size()
						for target in targets:
							gamestate.nodes[target].slowdown -= effect
			elif cmd=="translocate":
				var index := -1
				var move_to = targets[randi()%targets.size()]
				gamestate.nodes[ID].remove_program(self)
				ID = move_to
				index = gamestate.nodes[ID].add_program(self)
				# Move tooltip
				gamestate.Main.get_node("GUI/Tooltips").remove_child(tooltip)
				stop()
				if index>=0:
# warning-ignore:integer_division
					var d = 2*Vector2((index+1)%2,int(index/2))-Vector2(1,1)
					tooltip.rect_position = d*Vector2(192,128)
					tooltip.self_modulate = gamestate.colors[owner]
					tooltip.node = gamestate.nodes[ID].node
					gamestate.Main.get_node("GUI/Tooltips").add_child(tooltip)
			elif cmd=="clone":
				gamestate.Main.add_program(owner,type,ID)
			elif cmd=="terminate":
				stop()
			clear_command(pos)
	
# warning-ignore:shadowed_variable
	func init_command(pos,desc=null):
		var type = nodes[pos].type
		var args = nodes[pos].arguments
		var dirs = nodes[pos].dir
		var dir := -1
		var cpu_used := 0
		if typeof(Programs.COMMANDS[type].cpu)==TYPE_STRING:
			cpu_used = Programs.call(Programs.COMMANDS[type].cpu,args)
		else:
			cpu_used = Programs.COMMANDS[type].cpu
		if type=="sleep":
			if args.size()>0:
				delay = args[0]
			else:
				delay = 1.0
		elif typeof(Programs.COMMANDS[type].delay)==TYPE_STRING:
			delay = Programs.call(Programs.COMMANDS[type].delay,args)
		else:
			delay = Programs.COMMANDS[type].delay
		if gamestate.cpu[owner]<cpu_used:
			delay = 0.1
			node.get_node("VBoxContainer/Status/HBoxContainer/Label").text = tr("IDLE")
			finish_action(last)
			return false
		cpu += cpu_used
		gamestate.cpu[owner] -= cpu_used
		current_command = type
		if type=="if":
			dir = dirs[int(1-int(evaluate_statement(args)))]
		elif dirs.size()>0:
			dir = dirs[0]
		if type=="disrupt":
			var effect = args[0]/100.0/targets.size()
			for target in targets:
				gamestate.nodes[target].slowdown += effect
		stack[pos] = {"cpu":cpu_used,"command":type,"sustained":Programs.COMMANDS[type].sustained,"args":args,"dir":dir,"particles":[]}
		if desc!=null:
			node.get_node("VBoxContainer/Status/HBoxContainer/Label").text = tr(desc)
		else:
			node.get_node("VBoxContainer/Status/HBoxContainer/Label").text = ""
		node.get_node("VBoxContainer/Status").max_value = delay
		finish_action(last)
		goto(dir)
		last = pos
		return true
	
	func goto(dir):
		focus += Programs.get_offset(dir,focus)
		last = focus
	
	func skip():
		finish_action(last,true)
		if nodes[focus].dir.size()>0:
			goto(nodes[focus].dir[0])
		else:
			stop()
	
	func stop():
		gamestate.nodes[ID].remove_program(self)
		remove()
	
	func update(delta):
		status_delay -= delta
		if status_delay<=0.0:
			var pos = node.get_node("Code").text.find("\n")
			pos = node.get_node("Code").text.find("\n",pos+1)
			node.get_node("Code").text = node.get_node("Code").text.insert(pos,".")
			status_delay = 0.2
			ticks += 1
			if ticks>3:
				ticks = 0
				pos = node.get_node("Code").text.find("\n")
				node.get_node("Code").text = node.get_node("Code").text.substr(pos+1,node.get_node("Code").text.length()-pos-1)+"\n"+tr(nodes[focus].type.to_upper()+"_LINE"+str((randi()%5)+1))
	
	func evaluate_statement(array) -> bool:
		if array.size()==0:
			return false
		var t = array[0]
		if t=="true":
			return true
		elif t=="false":
			return false
		elif t=="connected":
			return targets.size()>0
		elif t=="connected_enemy":
			for target in targets:
				if gamestate.nodes[target].owner!=owner:
					return true
			return false
		elif t=="connected_controled":
			for target in targets:
				if gamestate.nodes[target].owner==owner:
					return true
			return false
		elif t=="enemy_adjacent":
			for p in gamestate.nodes[ID].connections:
				if gamestate.nodes[p].owner!=owner:
					return true
			return false
		elif t=="controled_adjacent":
			for p in gamestate.nodes[ID].connections:
				if gamestate.nodes[p].owner==owner:
					return true
			return false
		elif t=="unconnected_enemy":
			for p in gamestate.nodes[ID].connections:
				if gamestate.nodes[p].owner!=owner && !(p in targets):
					return true
			return false
		elif t=="unconnected_controled":
			for p in gamestate.nodes[ID].connections:
				if gamestate.nodes[p].owner==owner && !(p in targets):
					return true
			return false
		elif t=="hostile_program_adjacent":
			for p in gamestate.nodes[ID].connections:
				for prog in gamestate.nodes[p].programs:
					if prog.owner!=owner:
						return true
			return false
		elif t==">":
			if array.size()>2:
				return evaluate_var(array[1])>evaluate_var(array[2])
		elif t==">=":
			if array.size()>2:
				return evaluate_var(array[1])>=evaluate_var(array[2])
		elif t=="<":
			if array.size()>2:
				return evaluate_var(array[1])<evaluate_var(array[2])
		elif t=="<=":
			if array.size()>2:
				return evaluate_var(array[1])<=evaluate_var(array[2])
		elif t=="==":
			if array.size()>2:
				return evaluate_var(array[1])==evaluate_var(array[2])
		elif t=="!=":
			if array.size()>2:
				return evaluate_var(array[1])!=evaluate_var(array[2])
		return false
	
	func evaluate_var(s):
		if typeof(s)==TYPE_INT || typeof(s)==TYPE_REAL:
			return s
		elif typeof(s)==TYPE_STRING:
			if s=="cpu":
				return gamestate.cpu[owner]
			elif s=="control":
				var ret := 0.0
				for target in targets:
					var ctrl = gamestate.nodes[target].control[owner]
					for i in range(owner-1)+range(owner+1,gamestate.nodes[target].control.size()):
						ctrl -= gamestate.nodes[target].control[i]
					ret += ctrl
				return ret
			else:
				return str2var(s)
		return 0
	
	func acquire_target(s):
		var target := -1
		if s=="local":
			target = ID
		elif s=="random_enemy":
			var array = []
			for p in gamestate.nodes[ID].connections:
				if gamestate.nodes[p].owner!=owner && !(p in targets):
					array.push_back(p)
			if array.size()>0:
				target = array[randi()%array.size()]
		elif s=="random_controled":
			var array = []
			for p in gamestate.nodes[ID].connections:
				if gamestate.nodes[p].owner==owner && !(p in targets):
					array.push_back(p)
			if array.size()>0:
				target = array[randi()%array.size()]
		elif s=="random_node":
			var array = []
			for p in gamestate.nodes[ID].connections:
				if !(p in targets):
					array.push_back(p)
			if array.size()>0:
				target = array[randi()%array.size()]
		
		return target


func select(ID):
	# Player selected a control point.
	if node_selected>=0:
		var node = points[node_selected].node
		var tween = node.get_node("Select/Tween")
		tween.interpolate_property(node.get_node("Select"),"modulate",node.get_node("Select").modulate,Color(1.0,1.0,1.0,0.0),0.1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		tween.start()
	node_selected = ID
	if node_selected>=0:
		var node = points[node_selected].node
		var tween = node.get_node("Select/Tween")
		tween.interpolate_property(node.get_node("Select"),"modulate",node.get_node("Select").modulate,Color(1.0,1.0,1.0,1.0),0.1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		tween.start()
	$SoundClick.play()

func add_program(player,type,ID):
	# Add a new program.
	var tooltip
	var prgm
	var dir
	var index
	var prog := Programs.Program.new(Programs.programs[type])
	
	tooltip = effect_tooltip.instance()
	prgm = Program.new(type,prog,player,ID,gamestate,tooltip)
	index = points[ID].add_program(prgm)
	if index<0:
		return false
	
	dir = 2*Vector2((index+1)%2,floor(index/2))-Vector2(1,1)
	tooltip.rect_position = dir*Vector2(192,128)
	tooltip.self_modulate = colors[player]
	tooltip.node = points[ID].node
	tooltip.get_node("VBoxContainer/Status/HBoxContainer/ButtonCancel").hide()
	$GUI/Tooltips.add_child(tooltip)
	prgm.tooltip = tooltip
	
	return true

func _use_action(player,type):
	use_action(player,type,node_selected)

func use_action(player,type,ID):
	# Player selected an action.
	if !active:
		if started:
			active = true
		else:
			return false
	if !points[ID].has_access(player):
		return false
	
	var success = false
	if !programs[player].has(type) || programs[player][type]<=0:
		return false
	
	success = add_program(player,type,ID)
	if success:
		programs[player][type] -= 1
	if player==0:
		$GUI/Actions/GridContainer.get_node(type+"/LabelAmount").text = str(programs[player][type])+"x"
	return success

func get_winner():
	var player := -1
	var control := []
	var highest := 0
	control.resize(num_players+1)
	for i in range(control.size()):
		control[i] = 0
	
	if victory_on_root_capture:
		for j in range(num_players):
			for i in range(root_nodes[j].size()):
				var node = points[root_nodes[j][i]]
				if node.owner!=j:
					control[node.owner+1] += 1
	else:
		for node in points:
			if node.owner>=0:
				control[node.owner+1] += 1
			else:
				control[0] += 1
	
	for i in range(num_players+1):
		if control[i]>highest:
			highest = control[i]
			player = i-1
	
	return player


func hint():
	# Give visual hints to the player.
	# Used in the intro sequence.
	var valid_points := []
	var timer = Timer.new()
	for i in range(points.size()):
		if points[i].owner==0:
			valid_points.push_back(i)
	if valid_points.size()>0:
		var pi = click_particle.instance()
		var p = points[valid_points[randi()%valid_points.size()]]
		p.node.add_child(pi)
	if node_selected>=0 && points[node_selected].owner==0:
		var pi = click_particle.instance()
		var icons = $GUI/Actions/GridContainer.get_children()
		icons[randi()%icons.size()].add_child(pi)
	timer.wait_time = rand_range(2.0,8.0)
	timer.one_shot = true
	add_child(timer)
	timer.start()
	yield(timer,"timeout")
	timer.queue_free()
	hint()


func parse(prgm):
	# Execute the program's next command.
	if !prgm.nodes.has(prgm.focus):
		print("No valid node at "+str(prgm.focus)+"!")
		prgm.stop()
		return
	var pos = prgm.focus
	var node = prgm.nodes[pos]
	var type = node.type
	var wait := false
	
	if type=="disconnect":
		# Clear targets.
		wait = !prgm.init_command(prgm.focus,"DISCONNECTED")
		if !wait:
			prgm.targets = []
	elif type=="connect":
		# Add a target.
		wait = !prgm.init_command(prgm.focus,"CONNECTING")
		if !wait:
			var new_target = prgm.owner
			if node.arguments.size()>0:
				new_target = prgm.acquire_target(node.arguments[0])
				if new_target==-1:
					new_target = prgm.owner
			if !(new_target in prgm.targets):
				prgm.targets.push_back(new_target)
				if Options.show_particles:
					var pi = connection_particle.instance()
					pi.from = gamestate.nodes[prgm.ID].node
					pi.to = gamestate.nodes[new_target].node
					pi.duration = prgm.delay
					$ControlPoints.add_child(pi)
					if prgm.stack.has(pos):
						prgm.stack[pos].particles.push_back(pi)
	elif type=="attack":
		if prgm.targets.size()>0:
			# Attack!
			wait = !prgm.init_command(prgm.focus,"ATTACKING")
			if !wait:
				if Options.show_particles:
					for target in prgm.targets:
						var pi = pulse_particle.instance()
						pi.from = gamestate.nodes[prgm.ID].node
						pi.to = gamestate.nodes[target].node
						pi.duration = prgm.delay
						$ControlPoints.add_child(pi)
						if prgm.stack.has(pos):
							prgm.stack[pos].particles.push_back(pi)
		else:
			prgm.skip()
	elif type=="protect":
		if prgm.targets.size()>0:
			# Protect
			wait = !prgm.init_command(prgm.focus,"PROTECT")
			if !wait:
				if node.arguments.size()>0:
					for target in prgm.targets:
						var dam = node.arguments[0]
						prgm.gamestate.nodes[target].defend(prgm.owner,10*dam)
						if Options.show_particles:
							var pi = fire_wall_particle.instance()
							pi.node = gamestate.nodes[target].node
							$ControlPoints.add_child(pi)
							if prgm.stack.has(pos):
								prgm.stack[pos].particles.push_back(pi)
		else:
			prgm.skip()
	elif type=="disrupt":
		if prgm.targets.size()>0:
			# Disrupt
			wait = !prgm.init_command(prgm.focus,"DISRUPTING")
			if !wait:
				if Options.show_particles:
					for target in prgm.targets:
						var pi = disrupt_particle.instance()
						pi.node = gamestate.nodes[prgm.ID].node
						pi.target = gamestate.nodes[target].node
						$ControlPoints.add_child(pi)
						if prgm.stack.has(pos):
							prgm.stack[pos].particles.push_back(pi)
		else:
			prgm.skip()
	elif type=="translocate":
		if prgm.targets.size()>0:
			# Move to another node.
			wait = !prgm.init_command(prgm.focus,"TRANSLOCATE")
		else:
			prgm.skip()
	elif type=="if":
		wait = !prgm.init_command(prgm.focus,"EVALUATING")
	else:
		wait = !prgm.init_command(prgm.focus,type.to_upper())
	
	$GUI.update_prgms()


func _process(delta):
	tm += delta
	$Background.position = 0.8*$Camera.get_camera_screen_center()
	$Background/HexGrid.position = -$Background.position+$Camera.get_camera_screen_center()
	$Background/HexGrid.region_rect = Rect2($Background.position-OS.window_size/2*$Camera.zoom+Vector2(0.0,32.0*tm),OS.window_size*$Camera.zoom)
	$Background/HexGridD.position = $Background/HexGrid.position 
	$Background/HexGridD.region_rect = $Background/HexGrid.region_rect
	$GUI/Control/Time.value = time
	$GUI/Control/Time/Label.text = str(time).pad_decimals(1)+"s"
	
	if !active:
		return
	
	time -= delta
	if time<=0.0:
		stop()
		$GUI/Control/Time/Label.text = "0.0s"
		return
	
	for p in range(num_players):
		if AI.has_method(player_type[p]):
			AI.call(player_type[p],p)
	
	for p in points:
		for e in p.programs:
			var scale = p.control[e.owner]
			var t = 100.0
			for i in range(e.owner)+range(e.owner+1,num_players):
				t += p.control[i]
			scale /= t
			e.delay -= delta*scale*max(1.0-p.slowdown,0.0)
			if e.delay<=0.0:
				e.delay = 0.0
				parse(e)
			e.node.get_node("VBoxContainer/Duration").text = tr("REMAINING_TIME")%min(e.delay/max(scale,0.01),999.9)
			e.node.get_node("VBoxContainer/Status").value = e.node.get_node("VBoxContainer/Status").max_value-e.delay
			e.update(delta)

func _input(event):
	if event is InputEventMouseMotion && Input.is_action_pressed("screen_drag"):
		$Camera.position += (last_mouse_pos-get_local_mouse_position())*$Camera.zoom
		last_mouse_pos = get_local_mouse_position()
	if event.is_action_pressed("screen_drag"):
		last_mouse_pos = get_local_mouse_position()
	elif event.is_action_pressed("zoom_in"):
		$Camera.z = max($Camera.z-0.25,0.25)
	elif event.is_action_pressed("zoom_out"):
		$Camera.z = min($Camera.z+0.25,4.0)
	if !active && !started:
		return
	if event is InputEventKey && event.pressed:
		for i in range(9):
			if event.is_action("action"+str(i+1)) && programs[0].size()>=i:
				use_action(0,programs[0].keys()[i],node_selected)
		if event.is_action("action0") && programs[0].size()>=10:
			use_action(0,programs[0].keys()[10],node_selected)

func update_gui():
	var k = 0
	for c in $GUI/Actions/GridContainer.get_children():
		c.name = "deleted"
		c.queue_free()
	
	for action in programs[0].keys():
		var bi = action_button.instance()
		bi.action = action
		bi.hint_tooltip = tr(Programs.programs[action].name)
		bi.get_node("LabelKey").text = str(k+1)
		bi.get_node("LabelAmount").text = str(programs[0][action])+"x"
		bi.key = KEY_1+k
		bi.get_node("Icon").set_texture(load("res://images/icons/"+Programs.programs[action]["icon"]+".png"))
		if Programs.programs[action].has("cooldown"):
			bi.get_node("Cooldown").max_value = Programs.programs[action]["cooldown"]
		bi.name = action
		$GUI/Actions/GridContainer.add_child(bi)
		bi.connect("pressed",self,"_use_action",[0,programs[0].keys()[k]])
		k += 1

func reset():
	for c in $ControlPoints.get_children():
		c.name = "deleted"
		c.queue_free()

func start(np,_time,_cpu,_programs,_type,_colors,_points):
	reset()
	num_players = np
	cpu = []+_cpu
	max_cpu = []+_cpu
	programs = []+_programs
	colors = []+_colors
	player_type = []+_type
	points.resize(_points.size())
	gamestate = {"num_players":num_players,"nodes":points,"cpu":cpu,"max_cpu":max_cpu,"colors":colors,"programs":programs,"Main":self}
	for i in range(points.size()):
		var node = preload("res://scenes/main/node.tscn").instance()
		node.ID = i
		node.position = _points[i]["position"]
		for j in range(min(num_players,3)):
			node.get_node("Control"+str(j+1)).modulate = colors[j]
		$ControlPoints.add_child(node)
		points[i] = ControlPoint.new(i,num_players,_points[i]["position"],_points[i]["connections"],node,gamestate,_points[i]["owner"])
	
	$ControlPoints.update()
	time = _time
	$GUI/Control/Time.max_value = time
	AI.Main = self
	AI.gamestate = gamestate
	active = false
	started = true
	
	update_gui()

func stop():
	active = false
	started = false
	emit_signal("timeout",get_winner())


func create_radial_system(num_inner,num_outer,num_central,num_layers) -> Array:
# warning-ignore:shadowed_variable
	var points := []
	var num_layer := []
	var s := 0.0
	var last = num_inner
	points.resize(num_inner+num_outer+num_central)
	num_layer.resize(num_layers)
	for i in range(num_layers):
		num_layer[i] = (i+2.0)/num_layers*num_central
		s += num_layer[i]
	for i in range(num_layers):
		num_layer[i] = round(num_layer[i]/s*num_central)
	for i in range(num_inner):
		var c1 = floor(float(i)/num_inner*num_layer[0]+num_inner)
		var c2 = ceil(float(i)/num_inner*num_layer[0]+num_inner)
		points[i] = {"position":Vector2(192,0).rotated(2.0*PI*i/num_inner),"connections":[c1],"owner":1}
		root_nodes[1].push_back(i)
		if c1!=c2:
			points[i]["connections"].push_back(c2)
	for j in num_layers:
		for i in range(last,last+num_layer[j]):
			var c1
			var mean
			if j==0:
				mean = float(i-last)/num_layer[j]*num_inner+last-num_inner
				c1 = floor((mean+round(mean))/2.0)
			else:
				mean = float(i-last)/num_layer[j]*num_layer[j-1]+last-num_layer[j-1]
				c1 = floor((mean+round(mean))/2.0)
			points[i] = {"position":Vector2(192+256*(j+1),0).rotated(2.0*PI*(i-last)/num_layer[j]),"connections":[c1],"owner":-1}
		last += num_layer[j]
	for i in range(last-num_layer[num_layers-1],last):
		if randf()<0.4:
			var j = i+(randi()%2*2-1)
			if j>=last:
				j -= num_layer[num_layers-1]
			elif j<last-num_layer[num_layers-1]:
				j += num_layer[num_layers-1]
			points[i]["connections"].push_back(j)
			points[j]["connections"].push_back(i)
	points.resize(last+num_outer)
	for i in range(last,last+num_outer):
		var c1 = floor(float(i-last)/num_outer*num_layer[num_layers-1]+last-num_layer[num_layers-1])
		var c2 = ceil(float(i-last)/num_outer*num_layer[num_layers-1]+last-num_layer[num_layers-1])
		points[i] = {"position":Vector2(192+256*(num_layers+1),0).rotated(2.0*PI*(i-last)/num_outer),"connections":[c1],"owner":0}
		root_nodes[0].push_back(i)
		if c1!=c2:
			points[i]["connections"].push_back(c2)
	
	# make all connections two-way
	for i in range(points.size()):
		for j in range(points.size()):
			if j in points[i]["connections"] && !(i in points[j]["connections"]):
				points[j]["connections"].push_back(i)
	return points

func create_layered_system(num_layers,num_outer,num_nodes) -> Array:
	var nodes_per_layer
	var last
	var xoffset := 256.0
# warning-ignore:shadowed_variable
	var points := []
	var num_layer := []
	num_layer.resize(num_layers)
	num_layer[0] = num_outer
	num_layer[num_layers-1] = num_outer
	if num_nodes<2*num_outer+num_layers-2:
		printt("Warning: too few nodes for create_layered_system specified!")
		num_nodes = 2*num_outer+num_layers-2
	nodes_per_layer = int(round((num_nodes-2*num_outer)/(num_layers-2)))
	for i in range(1,num_layers-1):
		num_layer[i] = int(round(nodes_per_layer*rand_range(0.75,1.5)))
	
	num_nodes = 0
	for i in range(num_layers):
		num_nodes += num_layer[i]
	xoffset = xoffset*clamp(8.0/num_layers,1.0,2.0)
	
	points.resize(num_nodes)
	for i in range(num_outer):
		var c1 = clamp(floor(num_outer+float(i)/num_outer*num_layer[1]+rand_range(-0.4,0.4)),num_outer,num_outer+num_layer[1]-1)
		var c2 = clamp(ceil(num_outer+float(i)/num_outer*num_layer[1]+rand_range(-0.4,0.4)),num_outer,num_outer+num_layer[1]-1)
		points[i] = {"position":Vector2(-xoffset*(num_layers-1)/2.0,256.0*(i-num_outer/2.0)),"connections":[c1],"owner":0}
		root_nodes[0].push_back(i)
		if c1!=c2 && randf()<0.5:
			points[i]["connections"].push_back(c2)
	last = num_outer
	for i in range(1,num_layers-1):
		for j in range(last,last+num_layer[i]):
			points[j] = {"position":Vector2(xoffset*(i-(num_layers-1)/2.0),256.0*(j-last-num_layer[i]/2.0)),"connections":[],"owner":-1}
			if i<num_layers-2:
				var c1 = clamp(floor(last+num_layer[i]+float(j-last)/num_layer[i]*num_layer[i+1]+rand_range(-0.4,0.4)),last+num_layer[i],last+num_layer[i]+num_layer[i+1]-1)
				var c2 = clamp(ceil(last+num_layer[i]+float(j-last)/num_layer[i]*num_layer[i+1]+rand_range(-0.4,0.4)),last+num_layer[i],last+num_layer[i]+num_layer[i+1]-1)
				points[j]["connections"].push_back(c1)
				if c1!=c2 && randf()<0.25:
					points[j]["connections"].push_back(c2)
		last += num_layer[i]
	for i in range(last,last+num_outer):
		var c1 = clamp(floor(last-num_layer[num_layers-2]+float(i-last)/num_outer*num_layer[num_layers-2]+rand_range(-0.4,0.4)),last-num_layer[num_layers-2],last-1)
		var c2 = clamp(ceil(last-num_layer[num_layers-2]+float(i-last)/num_outer*num_layer[num_layers-2]+rand_range(-0.4,0.4)),last-num_layer[num_layers-2],last-1)
		points[i] = {"position":Vector2(xoffset*(num_layers-1)/2.0,256.0*(i-last-num_outer/2.0)),"connections":[c1],"owner":1}
		root_nodes[1].push_back(i)
		if c1!=c2 && randf()<0.5:
			points[i]["connections"].push_back(c2)
	
	# make all connections two-way
	for i in range(num_nodes):
		for j in range(num_nodes):
			if j in points[i]["connections"] && !(i in points[j]["connections"]):
				points[j]["connections"].push_back(i)
	return points

func create_radial_layer_system(num_inner,num_outer,num_central,num_layers) -> Array:
# warning-ignore:shadowed_variable
	var points := []
	var num_layer := []
	var s := 0.0
	var last = num_inner
	points.resize(num_inner+num_outer+num_central)
	num_layer.resize(num_layers)
	for i in range(num_layers):
		num_layer[i] = (i+2.0)/num_layers*num_central
		s += num_layer[i]
	for i in range(num_layers):
		num_layer[i] = round(num_layer[i]/s*num_central)
	for i in range(num_inner):
		var c1 = floor(float(i)/num_inner*num_layer[0]+num_inner)
		var c2 = ceil(float(i)/num_inner*num_layer[0]+num_inner)
		points[i] = {"position":Vector2(192,0).rotated(2.0*PI*i/num_inner),"connections":[c1],"owner":1}
		root_nodes[1].push_back(i)
		if c1!=c2:
			points[i]["connections"].push_back(c2)
	for j in num_layers:
		for i in range(last,last+num_layer[j]):
			var c1
			var c2
			var mean
			var k
			if j==0:
				mean = float(i-last)/num_layer[j]*num_inner+last-num_inner
				c1 = floor((mean+round(mean))/2.0)
				c2 = ceil((mean+round(mean))/2.0)
			else:
				mean = float(i-last)/num_layer[j]*num_layer[j-1]+last-num_layer[j-1]
				c1 = floor((mean+round(mean))/2.0)
				c2 = ceil((mean+round(mean))/2.0)
			points[i] = {"position":Vector2(192+256*(j+1),0).rotated(2.0*PI*(i-last)/num_layer[j]),"connections":[],"owner":-1}
			if randf()<0.25:
				points[i]["connections"].push_back(c1)
			if c1!=c2 && randf()<0.5:
				points[i]["connections"].push_back(c2)
			k = i+1
			if k>=last+num_layer[j]:
				k -= num_layer[j]
			elif k<last:
				k += num_layer[j]
			points[i]["connections"].push_back(k)
		last += num_layer[j]
	points.resize(last+num_outer)
	for i in range(last,last+num_outer):
		var c1 = floor(float(i-last)/num_outer*num_layer[num_layers-1]+last-num_layer[num_layers-1])
		var c2 = min(ceil(float(i-last)/num_outer*num_layer[num_layers-1]+last-num_layer[num_layers-1]+0.5),last+num_outer-1)
		points[i] = {"position":Vector2(192+256*(num_layers+1),0).rotated(2.0*PI*(i-last)/num_outer),"connections":[c1],"owner":0}
		root_nodes[0].push_back(i)
		if c1!=c2:
			points[i]["connections"].push_back(c2)
	
	# make all connections two-way
	for i in range(points.size()):
		for j in range(points.size()):
			if j in points[i]["connections"] && !(i in points[j]["connections"]):
				points[j]["connections"].push_back(i)
	return points

func create_hex_system(num_layers):
# warning-ignore:shadowed_variable
	var points := [{"position":Vector2(0,0),"connections":[],"owner":1}]
	var owner := -1
	var last_layer_start := 0
	
	for i in range(1,num_layers):
		var num_nodes := 6*i
		if i==num_layers-1:
			owner = 0
		for j in range(num_nodes):
			var pos := Vector2(0,320*i).rotated(2.0*PI*float(j)/float(num_nodes))
			var index = points.size()
			points.push_back({"position":pos,"connections":[],"owner":owner})
			if randf()<0.8/(1.0+i):
				points[index]["owner"] = 1
			for _k in range(1+randi()%2):
# warning-ignore:integer_division
				var c := int(clamp(round(last_layer_start+int(float(j)/float(num_nodes)*max(6*(i-1),1))+rand_range(-0.25,0.25)*(1.0+i)),last_layer_start,last_layer_start+6*(i-1)))
				if !points[index]["connections"].has(c):
					points[index]["connections"].push_back(c)
				if !points[c]["connections"].has(index):
					points[c]["connections"].push_back(index)
		last_layer_start = points.size()-num_nodes
	
	return points

func _ready():
	randomize()

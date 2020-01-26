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

var node_selected := -1

var action_button := preload("res://scenes/gui/action_button.tscn")
var effect_tooltip := preload("res://scenes/gui/effect_tooltip.tscn")
var pulse_particle := preload("res://scenes/particles/pulse.tscn")
var connection_particle := preload("res://scenes/particles/connection.tscn")
var fire_wall_particle := preload("res://scenes/particles/fire.tscn")


signal timeout(winner)


class ControlPoint:
	var position := Vector2()
	var connections := []
	var control := []
	var shield := []
	var max_shield := []
	var programs := []
	var used := []
	var ID := 0
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
		if player==owner:
			return true
		for p in connections:
			for program in gamestate.nodes[p].programs:
				if program.owner==player && program.type=="access":
					return true
		return false
	
	func check_owner():
		var new_owner = -1
		var max_value = 50
		if owner>=0:
			max_value = control[owner]
			if max_value>=50:
				new_owner = owner
		for i in range(control.size()):
			if control[i]>max_value:
				new_owner = i
		if owner!=new_owner:
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
		for program in programs:
			if program.owner!=owner:
				remove_program(program)
	
	func attack(player,amount):
#		print("damage node "+str(ID)+" for "+str(amount)+" damage")
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
		
		if mask_dmg<amount:
			var mi = mask.instance()
			mi.energy = (amount+mask_dmg)/100.0
			node.add_child(mi)
			mask_dmg += 25-amount
		else:
			mask_dmg -= amount
	
	func defend(player,amount):
#		print("defend node "+str(ID)+" for "+str(amount)+" damage")
		shield[player] += amount
		max_shield[player] += amount
		
		if mask_dmg<amount:
			var mi = mask.instance()
			mi.energy = (amount+mask_dmg)/100.0
			node.add_child(mi)
			mask_dmg += 25-amount
		else:
			mask_dmg -= amount
	
	func cancel_defense(player,amount):
#		print("defense of node "+str(ID)+" for "+str(amount)+" damage expired")
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
	var type := ""
	var prog
	var owner := -1
	var cpu : int
	var delay : float
	var line : int
	var last
	var gamestate
	var targets := []
	var current_command
	var stack := {}
	var ID := -1
# warning-ignore:unused_class_variable
	var index := -1
	var node
# warning-ignore:unused_class_variable
	var particles := []
	var tooltip
	
	func _init(_type,_prog,_player,_ID,_gamestate,_node):
		type = _type
		owner = _player
		ID = _ID
		targets = []
		prog = _prog
		cpu = 0
		gamestate = _gamestate
		delay = 2.0
		line = 0
		last = -1
		node = _node
		node.get_node("VBoxContainer/Status/HBoxContainer/Label").text = tr("INSTALLING")
		node.get_node("VBoxContainer/Status").max_value = delay
		node.get_node("Icon").set_texture(load(prog.icon))
		node.get_node("Code").text = tr("INSTALLING")+"\n"+tr("INSTALLING")+"\n"+tr("INSTALLING")
	
	func remove():
		gamestate.cpu[owner] += cpu
		cpu = 0
		delay = 0.0
		node.get_node("VBoxContainer/Status").value = 0
		node.get_node("VBoxContainer/Duration").text = tr("REMAINING_TIME")%0.0
		node.get_node("VBoxContainer/Status/HBoxContainer/Label").text = tr("TERMINATING")
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
	
# warning-ignore:shadowed_variable
	func finish_action(line):
		var code = prog.code[line]
		for i in range(stack.size()-1,-1,-1):
			var l = stack.keys()[i]
			if typeof(stack[l].sustained)==TYPE_STRING && stack[l].sustained in code:
				clear_command(l)
				break
		if !stack.has(line):
			return
		var cmd = stack[line].command
		if !stack[line].sustained:
			if cmd=="attack":
				var array = stack[line].args.split(" ",false)
				if array.size()>1:
					if targets.size()>0:
						var dam = str2var(array[1])/targets.size()
						for target in targets:
							gamestate.nodes[target].attack(owner,10*dam)
					else:
						var dam = str2var(array[1])
						gamestate.nodes[ID].attack(owner,10*dam)
			elif cmd=="protect":
				var array = stack[line].args.split(" ",false)
				if array.size()>1:
					if targets.size()>0:
						var dam = 0.5*str2var(array[1])/targets.size()
						for target in targets:
							gamestate.nodes[target].cancel_defense(owner,10*dam)
					else:
						var dam = 0.5*str2var(array[1])
						gamestate.nodes[ID].cancel_defense(owner,10*dam)
			elif cmd=="translocate":
				var index := -1
				var move_to = targets[randi()%targets.size()]
				init_command("disconnect","DISCONNECTED")
				gamestate.nodes[ID].remove_program(self)
				ID = move_to
				index = gamestate.nodes[ID].add_program(self)
				# Move tooltip
				gamestate.Main.get_node("GUI/Tooltips").remove_child(tooltip)
				if index>=0:
# warning-ignore:integer_division
					var dir = 2*Vector2((index+1)%2,int(index/2))-Vector2(1,1)
					tooltip.rect_position = dir*Vector2(192,128)
					tooltip.self_modulate = gamestate.colors[owner]
					tooltip.node = gamestate.points[ID].node
					gamestate.Main.get_node("GUI/Tooltips").add_child(tooltip)
			elif cmd=="copy":
				gamestate.Main.add_program(owner,type,ID)
			clear_command(line)
	
# warning-ignore:shadowed_variable
	func init_command(type,desc=null,args=null):
		var code_str := ""
		var cpu_used := 0
		if typeof(Programs.COMMANDS[type].cpu)==TYPE_STRING:
			cpu_used = Programs.call(Programs.COMMANDS[type].cpu,args)
		else:
			cpu_used = Programs.COMMANDS[type].cpu
		if type=="sleep":
			var array = args.split(" ",false)
			if array.size()>1:
				delay = str2var(array[1])
			else:
				delay = 1.0
		elif typeof(Programs.COMMANDS[type].delay)==TYPE_STRING:
			delay = Programs.call(Programs.COMMANDS[type].delay,args)
		else:
			delay = Programs.COMMANDS[type].delay
		if gamestate.cpu[owner]<cpu_used:
#			print("Allocating "+str(cpu_used)+" cpu failed!")
			delay = 0.1
			node.get_node("VBoxContainer/Status/HBoxContainer/Label").text = tr("IDLE")
			finish_action(last)
			return false
		cpu += cpu_used
		gamestate.cpu[owner] -= cpu_used
		current_command = type
		stack[line] = {"cpu":cpu_used,"command":type,"sustained":Programs.COMMANDS[type].sustained,"args":args,"particles":[]}
		if desc!=null:
			node.get_node("VBoxContainer/Status/HBoxContainer/Label").text = tr(desc)
		node.get_node("VBoxContainer/Status").max_value = delay
		for i in range(-1,2):
			if line+i>=0 && line+i<prog.code.size():
				code_str += prog.code[line+i]+"\n"
			else:
				code_str += "\n"
		node.get_node("Code").text = code_str
		finish_action(last)
		last = line
		return true
	
	func goto(new):
		line = new
		finish_action(last)
		last = line
	
	func stop():
		gamestate.nodes[ID].remove_program(self)
		remove()
	


func select(ID):
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
	var tooltip
	var prgm
	var dir
	var index
	var prog = Programs.Program.new(Programs.programs[type])
	
	tooltip = effect_tooltip.instance()
	prgm = Program.new(type,prog,player,ID,gamestate,tooltip)
	index = points[ID].add_program(prgm)
	if index<0:
		return false
	
	dir = 2*Vector2((index+1)%2,floor(index/2))-Vector2(1,1)
	tooltip.rect_position = dir*Vector2(192,128)
	tooltip.self_modulate = colors[player]
	tooltip.node = points[ID].node
	if player==0:
		tooltip.get_node("VBoxContainer/Status/HBoxContainer/ButtonCancel").connect("pressed",points[ID],"remove_program",[prgm])
	else:
		tooltip.get_node("VBoxContainer/Status/HBoxContainer/ButtonCancel").hide()
	$GUI/Tooltips.add_child(tooltip)
	prgm.tooltip = tooltip
	
	return true

func use_action(player,type,ID):
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
	var player = -1
	var control = []
	var highest = 0
	control.resize(num_players+1)
	for i in range(control.size()):
		control[i] = 0
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


func parse(prgm):
	# Parse the program.
	var code = prgm.prog.code
	var line = code[prgm.line]
	var wait := false
#	print("parsing "+prgm.type+" line "+str(prgm.line)+": "+line+" ...")
	
	if !("//" in line):
		if "return" in line:
			# Stop program.
			wait = !prgm.init_command("return","TERMINATING")
			prgm.stop()
			return
		elif "disconnect" in line:
			# Clear target.
			wait = !prgm.init_command("disconnect","DISCONNECTED")
			if !wait:
				prgm.targets = [prgm.ID]
		elif "connect" in line:
			# Set target.
			var new_target = prgm.owner
			wait = !prgm.init_command("connect","CONNECTING")
			if !wait:
				if "local" in line:
					new_target = prgm.ID
				elif "random_enemy" in line:
					var array = []
					for p in prgm.gamestate.nodes[prgm.ID]["connections"]:
						if prgm.gamestate.nodes[p].owner!=prgm.owner:
							array.push_back(p)
					if array.size()>0:
						new_target = array[randi()%array.size()]
				elif "random_controled" in line:
					var array = []
					for p in prgm.gamestate.nodes[prgm.ID]["connections"]:
						if prgm.gamestate.nodes[p].owner==prgm.owner:
							array.push_back(p)
					if array.size()>0:
						new_target = array[randi()%array.size()]
				elif "random_node" in line:
					var p = prgm.gamestate.nodes[prgm.ID]["connections"]+[prgm.ID]
					new_target = p[randi()%p.size()]
				else:
					new_target = get_args(prgm)
					if new_target==null || !(new_target in prgm.gamestate.nodes[prgm.ID]["connections"]):
						new_target = prgm.ID
				if !(new_target in prgm.targets):
					var pi = connection_particle.instance()
					prgm.targets.push_back(new_target)
					pi.from = gamestate.nodes[prgm.ID].node
					pi.to = gamestate.nodes[new_target].node
					pi.duration = prgm.delay
					$ControlPoints.add_child(pi)
					if prgm.stack.has(prgm.line):
						prgm.stack[prgm.line].particles.push_back(pi)
		elif "attack" in line && prgm.targets.size()>0:
			# Attack!
			wait = !prgm.init_command("attack","ATTACKING",line)
			if !wait:
				for target in prgm.targets:
					var pi = pulse_particle.instance()
					pi.from = gamestate.nodes[prgm.ID].node
					pi.to = gamestate.nodes[target].node
					pi.duration = prgm.delay
					$ControlPoints.add_child(pi)
					prgm.stack[prgm.line].particles.push_back(pi)
		elif "protect" in line && prgm.targets.size()>0:
			# Protect
			wait = !prgm.init_command("protect","PROTECT",line)
			if !wait:
				var array = line.split(" ",false)
				if array.size()>1:
					for target in prgm.targets:
						var pi = fire_wall_particle.instance()
						var dam = str2var(array[1])
						prgm.gamestate.nodes[target].defend(prgm.owner,10*dam)
						pi.node = gamestate.nodes[target].node
						$ControlPoints.add_child(pi)
						prgm.stack[prgm.line].particles.push_back(pi)
					if prgm.targets.size()==0:
						var pi = fire_wall_particle.instance()
						var dam = str2var(array[1])
						prgm.gamestate.nodes[prgm.ID].defend(prgm.owner,10*dam)
						pi.node = gamestate.nodes[prgm.ID].node
						$ControlPoints.add_child(pi)
						prgm.stack[prgm.line].particles.push_back(pi)
		elif "translocate" in line && prgm.targets.size()>0:
			# Move to another node.
			wait = !prgm.init_command("translocate","TRANSLOCATE",line)
			if !wait:
				pass
		elif "clone" in line:
			# Make a copy of the program.
			wait = !prgm.init_command("clone","CLONE",line)
			if !wait:
				pass
		elif "sleep" in line:
			wait = !prgm.init_command("sleep","IDLE",line)
		elif "if" in line:
			# Do not execute the rest of the block if statement is false.
			wait = !prgm.init_command("if")
			if !wait:
				var val = evaluate_statement(prgm,line)
				if !val:
					skip_block(prgm)
					return
		elif "else" in line:
			# Do not execute the rest of the block if the previous if statement was true.
			wait = !prgm.init_command("else")
			if !wait:
				var val = !evaluate_last_statement(prgm,prgm.line)
				if !val:
					skip_block(prgm)
					return
		elif "for" in line:
			# For loop.
			var set = []
			wait = !prgm.init_command("for",null,{"set":set,"index":0})
			if !wait:
				if "enemy_nodes" in line:
					for p in gamestate.nodes[prgm.ID]["connections"]:
						if prgm.gamestate.nodes[p].owner!=prgm.owner:
							set.push_back(p)
				elif "controled_nodes" in line:
					for p in prgm.gamestate.nodes[prgm.ID]["connections"]:
						if prgm.gamestate.nodes[p].owner==prgm.owner:
							set.push_back(p)
				elif "all_nodes" in line:
					set += prgm.gamestate.nodes[prgm.ID]["connections"]
				else:
					var array = line.split("in")
					if array.size()>1:
						var num = str2var(array[1])
						if typeof(num)==TYPE_INT || typeof(num)==TYPE_REAL:
							set = range(int(num))
				if set.size()==0:
					skip_block(prgm)
		elif "while" in line:
			# While loop.
			wait = !prgm.init_command("while")
			if !wait:
				var val = evaluate_statement(prgm,line)
				if !val:
					skip_block(prgm)
		elif "end" in line:
			var offset = 0
			for l in range(prgm.line-1,-1,-1):
				if "end" in code[l]:
					offset += 1
				if "if" in code[l] || "for" in code[l] || "while" in code[l]:
					offset -= 1
				if offset<0:
					if "if" in code[l]:
						prgm.finish_action(prgm.line)
						break
					elif "for" in code[l]:
						for_loop(prgm,l)
						return
					elif "while" in code[l]:
						while_loop(prgm,l)
						return
		elif "continue" in line:
			skip_block(prgm)
		elif "break" in line:
			skip_block(prgm,1)
		
	
	if !wait:
		prgm.line += 1
		if prgm.line>=prgm.prog.code.size():
			prgm.stop()
#	else:
#		printt("can't proceed...")
	pass

func evaluate_statement(prgm,line):
	if "_true" in line:
		return true
	elif "_false" in line:
		return false
	elif "connected" in line:
		return prgm.targets.size()>1 && (prgm.targets.size()>2 || prgm.targets[0]!=prgm.owner)
	elif "controled" in line:
		for target in prgm.targets:
			if gamestate.nodes[target].owner==prgm.owner:
				return true
		return false
	elif "enemy_adjacent" in line:
		for p in gamestate.nodes[prgm.ID].connections:
			if gamestate.nodes[p].owner!=prgm.owner:
				return true
	elif "controled_adjacent" in line:
		for p in gamestate.nodes[prgm.ID].connections:
			if gamestate.nodes[p].owner==prgm.owner:
				return true
	elif "hostile_program_adjacent" in line:
		for p in gamestate.nodes[prgm.ID].connections:
			for prog in gamestate.nodes[p].programs:
				if prog.owner!=prgm.owner:
					return true
	elif ">" in line:
		var array = line.replace("if","").split(">")
		if array.size()==2:
			return evaluate_var(prgm,array[0])>evaluate_var(prgm,array[1])
	elif ">=" in line:
		var array = line.replace("if","").split(">=")
		if array.size()==2:
			return evaluate_var(prgm,array[0])>=evaluate_var(prgm,array[1])
	elif "<" in line:
		var array = line.replace("if","").split("<")
		if array.size()==2:
			return evaluate_var(prgm,array[0])<evaluate_var(prgm,array[1])
	elif "<=" in line:
		var array = line.replace("if","").split("<=")
		if array.size()==2:
			return evaluate_var(prgm,array[0])<=evaluate_var(prgm,array[1])
	elif "==" in line:
		var array = line.replace("if","").split("==")
		if array.size()==2:
			return evaluate_var(prgm,array[0])==evaluate_var(prgm,array[1])
	elif "!=" in line:
		var array = line.replace("if","").split("!=")
		if array.size()==2:
			return evaluate_var(prgm,array[0])!=evaluate_var(prgm,array[1])
	return false

func evaluate_last_statement(prgm,line):
	var code = prgm.prog.code
	var offset = 0
	for l in range(line-1,-1,-1):
		if "end" in code[l]:
			offset -= 1
		elif "if" in code[l] || "for" in code[l] || "while" in code[l]:
			offset += 1
		if offset>0:
			return evaluate_statement(prgm,code[l])

func evaluate_var(prgm,s):
	if "cpu" in s:
		return gamestate.cpu[prgm.owner]
	elif "control" in s:
		var ret := 0.0
		for target in prgm.targets:
			var ctrl = gamestate.nodes[target].control[prgm.owner]
			for i in range(prgm.owner-1)+range(prgm.owner+1,gamestate.nodes[target].control.size()):
				ctrl -= gamestate.nodes[target].control[i]
			ret += ctrl
		return ret
	else:
		var ret = str2var(s)
		if typeof(ret)==TYPE_REAL || typeof(ret)==TYPE_INT:
			return ret
		else:
			return 0

func skip_block(prgm,ofs=0):
	var code = prgm.prog.code
	var offset = 0
	for l in range(prgm.line+1,code.size()):
		prgm.line = l
		if "end" in code[l]:
			offset -= 1
		elif ("elif" in code[l] || "else" in code[l]) && offset==0:
#			if !evaluate_last_statement(prgm,prgm.line):
			prgm.line -= 1
			break
		elif "if" in code[l] || "for" in code[l] || "while" in code[l]:
			offset += 1
		
		if offset<0:
			break
	prgm.line += ofs
#	printt("goto ->",prgm.line)



func for_loop(prgm,start):
	prgm.stack[start].args.index += 1
	if prgm.stack[start].args.index>=prgm.stack[start].args.set.size():
		prgm.line += 1
		prgm.finish_action(start)
		return
	prgm.goto(start+1)

func while_loop(prgm,start):
	var val = evaluate_statement(prgm,prgm.prog.code[start])
	if !val:
		prgm.line += 1
		prgm.finish_action(start)
		return
	prgm.goto(start+1)

func get_args(prgm):
	var code = prgm.prog.code
	var line = code[prgm.line]
	var array = line.split(" ")
	if array.size()<2:
		return
	var id = array[1]
	for l in range(prgm.line-1,-1,-1):
		if "for" in code[l] && id in code[l] && prgm.stack.has(l):
			if prgm.stack[l].args.set.size()==0:
				return
			else:
				return prgm.stack[l].args.set[prgm.stack[l].args.index]
	return


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
#			var code_str = ""
#			var code = e.prog.code
			var scale = p.control[e.owner]
			var t = 100.0
			for i in range(e.owner)+range(e.owner+1,num_players):
				t += p.control[i]
			scale /= t
			e.delay -= delta*scale
			if e.delay<=0.0:
				e.delay = 0.0
				parse(e)
			e.node.get_node("VBoxContainer/Duration").text = tr("REMAINING_TIME")%(e.delay/scale)
			e.node.get_node("VBoxContainer/Status").value = e.node.get_node("VBoxContainer/Status").max_value-e.delay

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
		bi.get_node("LabelKey").text = str(k+1)
		bi.get_node("LabelAmount").text = str(programs[0][action])+"x"
		bi.key = KEY_1+k
		bi.get_node("Icon").set_texture(load("res://images/icons/"+Programs.programs[action]["icon"]+".png"))
		if Programs.programs[action].has("cooldown"):
			bi.get_node("Cooldown").max_value = Programs.programs[action]["cooldown"]
		bi.name = action
		$GUI/Actions/GridContainer.add_child(bi)
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
		for i in range(min(num_players,3)):
			node.get_node("Control"+str(i+1)).modulate = colors[i]
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
	printt("Start!")

func stop():
	active = false
	started = false
	emit_signal("timeout",get_winner())
	printt("Stop!")


func create_radial_system(num_inner,num_outer,num_central,num_layers):
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
		if c1!=c2:
			points[i]["connections"].push_back(c2)
	for j in num_layers:
		for i in range(last,last+num_layer[j]):
			var c1
#			var c2
			var mean
			if j==0:
				mean = float(i-last)/num_layer[j]*num_inner+last-num_inner
				c1 = floor((mean+round(mean))/2.0)
#				c2 = ceil((mean+round(mean))/2.0)
			else:
				mean = float(i-last)/num_layer[j]*num_layer[j-1]+last-num_layer[j-1]
				c1 = floor((mean+round(mean))/2.0)
#				c2 = ceil((mean+round(mean))/2.0)
			points[i] = {"position":Vector2(192+256*(j+1),0).rotated(2.0*PI*(i-last)/num_layer[j]),"connections":[c1],"owner":-1}
#			if c1!=c2:
#				points[i]["connections"].push_back(c2)
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
		if c1!=c2:
			points[i]["connections"].push_back(c2)
	
	# make all connections two-way
	for i in range(points.size()):
		for j in range(points.size()):
			if j in points[i]["connections"] && !(i in points[j]["connections"]):
				points[j]["connections"].push_back(i)
	return points

func create_layered_system(num_layers,num_outer,num_nodes):
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
		if c1!=c2 && randf()<0.5:
			points[i]["connections"].push_back(c2)
	
	# make all connections two-way
	for i in range(num_nodes):
		for j in range(num_nodes):
			if j in points[i]["connections"] && !(i in points[j]["connections"]):
				points[j]["connections"].push_back(i)
	return points

func create_radial_layer_system(num_inner,num_outer,num_central,num_layers):
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
		if c1!=c2:
			points[i]["connections"].push_back(c2)
	
	# make all connections two-way
	for i in range(points.size()):
		for j in range(points.size()):
			if j in points[i]["connections"] && !(i in points[j]["connections"]):
				points[j]["connections"].push_back(i)
	return points

func _ready():
	randomize()

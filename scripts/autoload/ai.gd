extends Node

# Very basic computer player.

var Main
var gamestate


func ai_random(player):
	if gamestate.cpu[player]<=0.0:
		return
	
	var programs := sort_random(get_available_programs(player))
	var nodes := get_owned_points(player)
#	if gamestate.cpu[player]-2<0.1*gamestate.max_cpu[player]:
#		cancel_random_program(player)
#		return
	if nodes.size()==0 || gamestate.cpu[player]<gamestate.max_cpu[player]/10 || gamestate.cpu[player]<get_mean_program_cpu(player):
		# No nodes or low on CPU.
		return
	for program in programs:
		# Go trough all available programs in random order.
		var ID = nodes[randi()%nodes.size()]
		if gamestate.cpu[player]<Programs.Program.new(Programs.programs[program]).mean_cpu:
			# Not enough CPU.
			continue
		if program=="pulse" || program=="wave" || program=="scythe":
			if is_adjacent_to_unowned(player,ID):
				Main.use_action(player,program,ID)
				break
		elif program=="worm":
			if gamestate.cpu[player]>9 && is_adjacent_to_unowned(player,ID):
				Main.use_action(player,program,ID)
				break
		elif program=="phalanx" || program=="parry":
			if is_adjacent_to_enemy(player,ID):
				Main.use_action(player,program,ID)
				break
		elif program=="anti_virus":
			if is_damaged(player,ID):
				Main.use_action(player,program,ID)
				break
		elif program=="fire_wall" || program=="lock" || program=="silence":
			if is_adjacent_to_enemy(player,ID) && gamestate.cpu[player]>gamestate.max_cpu[player]/3:
				Main.use_action(player,program,ID)
				break
		else:
			Main.use_action(player,program,ID)
			break


func sort_random(array : Array) -> Array:
	for _k in range(array.size()):
		var i := randi()%array.size()
		var j := randi()%array.size()
		var tmp = array[j]
		array[j] = array[i]
		array[i] = tmp
	return array

func get_available_programs(player) -> Array:
	var programs := []
	for program in gamestate.programs[player].keys():
		programs.push_back(program)
	return programs

func get_owned_points(player) -> Array:
	var nodes := []
	for i in range(gamestate.nodes.size()):
		if gamestate.nodes[i].has_access(player):
			nodes.push_back(i)
	return nodes

func get_running_programs(player) -> int:
	var num := 0
	for node in gamestate.nodes:
		for prgm in node.programs:
			if prgm.owner==player:
				num += 1
	return num

func get_mean_program_cpu(player) -> int:
	var cpu := 0
	for node in gamestate.nodes:
		for prgm in node.programs:
			if prgm.owner==player:
				cpu += prgm.prgm.mean_cpu
	return cpu

func is_adjacent_to_enemy(player,ID) -> bool:
	for p in gamestate.nodes[ID]["connections"]:
		if gamestate.nodes[p].owner>=0 && gamestate.nodes[p].owner!=player:
			return true
	return false

func is_adjacent_to_unowned(player,ID) -> bool:
	for p in gamestate.nodes[ID]["connections"]:
		if gamestate.nodes[p].owner!=player:
			return true
	return false

func is_damaged(player,ID) -> bool:
	if gamestate.nodes[ID].control[player]<90:
		return true
	for i in range(player)+range(player+1,gamestate.nodes[ID].control.size()):
		if gamestate.nodes[ID].control[i]>10:
			return true
	return false

func has_program(ID,type) -> bool:
	for p in gamestate.nodes[ID].programs:
		if p.type==type:
			return true
	return false

func cancel_random_program(player) -> bool:
	var programs := []
	var nodes := []
	for node in gamestate.nodes:
		for prgm in node.programs:
			if prgm.owner==player:
				programs.push_back(prgm)
				nodes.push_back(node)
	if programs.size()>0:
		var index = randi()%programs.size()
		nodes[index].remove_program(programs[index])
		return true
	return false

extends Node

var Main
var gamestate


func ai_random(player):
	if gamestate.cpu[player]<=0.0:
		return
	
	var programs = get_available_programs(player)
	var nodes = get_owned_points(player)
	if gamestate.cpu[player]-2<0.1*gamestate.max_cpu[player]:
		cancel_random_program(player)
		return
	if nodes.size()==0 || gamestate.cpu[player]<min(0.2*gamestate.max_cpu[player],3+0.5*sqrt(gamestate.max_cpu[player])) || get_running_programs(player)>sqrt(gamestate.max_cpu[player]-3.0)/2.0+rand_range(-2.0,1.0):
		return
	for program in programs:
		var ID = nodes[randi()%nodes.size()]
		var has_program = has_program(ID,program)
		if has_program || gamestate.cpu[player]<Programs.Program.new(Programs.programs[program]).mean_cpu:
			return
		if (program=="pulse" || program=="wave" || (program=="worm" && gamestate.cpu[player]>9)) && is_adjacent_to_unowned(player,ID) && randf()<0.5:
			Main.use_action(player,program,ID)
		elif program=="phalanx" && is_adjacent_to_enemy(player,ID) && randf()<0.25:
			Main.use_action(player,program,ID)
		elif program=="anti_virus" && is_damaged(player,ID) && randf()<0.5:
			Main.use_action(player,program,ID)
		elif program=="fire_wall" && is_adjacent_to_enemy(player,ID) && randf()<0.25*gamestate.cpu[player]/gamestate.max_cpu[player]:
			Main.use_action(player,program,ID)
	


func get_available_programs(player)->Array:
	var programs := []
	for program in gamestate.programs[player].keys():
		programs.push_back(program)
	return programs

func get_owned_points(player)->Array:
	var nodes := []
	for i in range(gamestate.nodes.size()):
		if gamestate.nodes[i].has_access(player):
			nodes.push_back(i)
	return nodes

func get_running_programs(player)->int:
	var num := 0
	for node in gamestate.nodes:
		for prgm in node.programs:
			if prgm.owner==player:
				num += 1
	return num

func is_adjacent_to_enemy(player,ID)->bool:
	for p in gamestate.nodes[ID]["connections"]:
		if gamestate.nodes[p].owner>=0 && gamestate.nodes[p].owner!=player:
			return true
	return false

func is_adjacent_to_unowned(player,ID)->bool:
	for p in gamestate.nodes[ID]["connections"]:
		if gamestate.nodes[p].owner!=player:
			return true
	return false

func is_damaged(player,ID)->bool:
	if gamestate.nodes[ID].control[player]<90:
		return true
	for i in range(player)+range(player+1,gamestate.nodes[ID].control.size()):
		if gamestate.nodes[ID].control[i]>10:
			return true
	return false

func has_program(ID,type)->bool:
	for p in gamestate.nodes[ID].programs:
		if p.type==type:
			return true
	return false

func cancel_random_program(player):
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

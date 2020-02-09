extends Node

# Predefined programs.

const ANTI_VIRUS = {
	Vector2( 9, 4):{"type":"initialize","dir":[0]},
	Vector2(10, 5):{"type":"if","arguments":["enemy_adjacent"],"dir":[0,2]},
	Vector2(11, 5):{"type":"if","arguments":["<","control",100],"dir":[5,2]},
	Vector2(12, 5):{"type":"connect","arguments":["local"],"dir":[3]},
	Vector2(11, 4):{"type":"attack","arguments":[2],"dir":[3]},
	Vector2(10, 4):{"type":"disconnect","dir":[1]},
	Vector2(10, 6):{"type":"sleep","arguments":[2.0],"dir":[4]},
	Vector2( 9, 5):{"type":"terminate"}
}

const PULSE = {
	Vector2( 9, 4):{"type":"initialize","dir":[0]},
	Vector2(10, 5):{"type":"if","arguments":["enemy_adjacent"],"dir":[0,2]},
	Vector2(11, 5):{"type":"connect","arguments":["random_enemy"],"dir":[5]},
	Vector2(12, 5):{"type":"attack","arguments":[3],"dir":[3]},
	Vector2(11, 4):{"type":"disconnect","dir":[2]},
	Vector2( 9, 5):{"type":"terminate"}
}

const WAVE = {
	Vector2( 9, 4):{"type":"initialize","dir":[0]},
	Vector2(10, 5):{"type":"if","arguments":["unconnected_enemy"],"dir":[0,2]},
	Vector2(11, 5):{"type":"connect","arguments":["random_enemy"],"dir":[3]},
	Vector2( 9, 5):{"type":"attack","arguments":[5],"dir":[2]},
	Vector2( 8, 6):{"type":"disconnect","dir":[2]},
	Vector2( 7, 6):{"type":"terminate"}
}

const FIRE_WALL = {
	Vector2( 9, 4):{"type":"initialize","dir":[0]},
	Vector2(10, 5):{"type":"if","arguments":["enemy_adjacent"],"dir":[0,2]},
	Vector2(11, 5):{"type":"connect","arguments":["local"],"dir":[5]},
	Vector2(12, 5):{"type":"protect","arguments":[3],"dir":[3]},
	Vector2(11, 4):{"type":"disconnect","dir":[2]},
	Vector2( 9, 5):{"type":"terminate"}
}

const PHALANX = {
	Vector2( 9, 4):{"type":"initialize","dir":[0]},
	Vector2(10, 5):{"type":"if","arguments":["enemy_adjacent"],"dir":[0,2]},
	Vector2(11, 4):{"type":"disconnect","dir":[2]},
	Vector2(11, 5):{"type":"if","arguments":["<","control",80],"dir":[1,0]},
	Vector2(11, 6):{"type":"connect","arguments":["local"],"dir":[1]},
	Vector2(11, 7):{"type":"attack","arguments":[2],"dir":[5]},
	Vector2(12, 7):{"type":"disconnect","dir":[4]},
	Vector2(12, 5):{"type":"attack","arguments":[4],"dir":[3]},
	Vector2(12, 6):{"type":"if","arguments":["hostile_program_adjacent"],"dir":[0,5]},
	Vector2(13, 6):{"type":"connect","arguments":["local"],"dir":[0]},
	Vector2(14, 7):{"type":"protect","arguments":[2],"dir":[4]},
	Vector2(14, 6):{"type":"disconnect","dir":[3]},
	Vector2(13, 5):{"type":"connect","arguments":["random_enemy"],"dir":[3]},
	Vector2( 9, 5):{"type":"terminate"}
}

const WORM = {
	Vector2( 8, 4):{"type":"initialize","dir":[0]},
	Vector2( 9, 4):{"type":"if","arguments":[">","cpu",75],"dir":[0,2]},
	Vector2( 8, 5):{"type":"terminate"},
	Vector2(10, 5):{"type":"if","arguments":["enemy_adjacent"],"dir":[1,0]},
	Vector2(10, 6):{"type":"connect","arguments":["random_enemy"],"dir":[1]},
	Vector2(10, 7):{"type":"attack","arguments":[3],"dir":[5]},
	Vector2(11, 6):{"type":"disconnect","dir":[4]},
	Vector2(11, 5):{"type":"if","arguments":[">","control",75],"dir":[5,0]},
	Vector2(10, 4):{"type":"disconnect","dir":[2]},
	Vector2(11, 3):{"type":"translocate","arguments":[],"dir":[2]},
	Vector2(12, 4):{"type":"connect","arguments":["random_controled"],"dir":[3]},
	Vector2(12, 5):{"type":"clone","arguments":[],"dir":[4]},
	Vector2(12, 6):{"type":"connect","arguments":["local"],"dir":[5]},
	Vector2(13, 4):{"type":"connect","arguments":["local"],"dir":[3]},
	Vector2(13, 5):{"type":"attack","arguments":[2],"dir":[4]}
}

const AGENT = {
	Vector2( 8, 5):{"type":"initialize","dir":[5]},
	Vector2( 9, 4):{"type":"if","arguments":["controled_adjacent"],"dir":[4,1]},
	Vector2( 9, 5):{"type":"terminate"},
	Vector2( 9, 2):{"type":"connect","arguments":["random_enemy"],"dir":[5]},
	Vector2(10, 2):{"type":"attack","arguments":[1],"dir":[1]},
	Vector2( 9, 3):{"type":"if","arguments":["controled_adjacent"],"dir":[4,0]},
	Vector2(10, 3):{"type":"disconnect","dir":[2]},
	Vector2(10, 4):{"type":"connect","arguments":["random_controled"],"dir":[0]},
	Vector2(11, 4):{"type":"translocate","dir":[2]},
	Vector2(10, 5):{"type":"disconnect","dir":[3]}
}


const COMMANDS = {
	"initialize":{
		"cpu":1,
		"size":1,
		"cost":30,
		"delay":2.0,
		"argument":"none",
		"sustained":"return"},
	"terminate":{
		"cpu":0,
		"size":0,
		"cost":20,
		"delay":1.0,
		"argument":"none",
		"sustained":false},
#	"end":{
#		"cpu":0,
#		"size":0,
#		"cost":0,
#		"delay":0,
#		"sustained":false},
#	"continue":{
#		"cpu":0,
#		"size":0,
#		"cost":0,
#		"delay":0,
#		"sustained":false},
#	"break":{
#		"cpu":0,
#		"size":0,
#		"cost":0,
#		"delay":0,
#		"sustained":false},
	"disconnect":{
		"cpu":1,
		"size":1,
		"cost":20,
		"delay":0.5,
		"argument":"none",
		"sustained":false},
	"connect":{
		"cpu":1,
		"size":1,
		"cost":50,
		"delay":0.5,
		"argument":"target",
		"sustained":"disconnect"},
	"attack":{
		"cpu":"attack_cpu",
		"size":4,
		"cost":100,
		"delay":"attack_delay",
		"argument":"number",
		"sustained":false},
	"protect":{
		"cpu":"attack_cpu",
		"size":3,
		"cost":100,
		"delay":"protect_delay",
		"argument":"number",
		"sustained":false},
	"translocate":{
		"cpu":4,
		"size":4,
		"cost":200,
		"delay":5.0,
		"argument":"none",
		"sustained":false},
	"clone":{
		"cpu":4,
		"size":8,
		"cost":350,
		"delay":2.0,
		"argument":"none",
		"sustained":false},
	"sleep":{
		"cpu":0,
		"size":1,
		"cost":20,
		"delay":1.0,
		"argument":"number",
		"sustained":false},
	"if":{
		"cpu":2,
		"size":4,
		"cost":50,
		"delay":0.1,
		"argument":"statement",
		"sustained":false},
#	"else":{
#		"cpu":1,
#		"size":1,
#		"cost":50,
#		"delay":0.0,
#		"sustained":"end"},
#	"elif":{
#		"cpu":1,
#		"size":1,
#		"cost":50,
#		"delay":0.0,
#		"sustained":"end"},
#	"for":{
#		"cpu":1,
#		"size":1,
#		"cost":75,
#		"delay":0.0,
#		"sustained":"end"},
#	"while":{
#		"cpu":1,
#		"size":2,
#		"cost":100,
#		"delay":0.0,
#		"sustained":"end"},
	
}

const STATEMENTS = [
	"true",
	"connected",
	"enemy_adjacent",
	"controled_adjacent",
	"connected_enemy",
	"connected_controled",
	"unconnected_enemy",
	"unconnected_controled",
	"hostile_program_adjacent",
	"==",
	"!=",
	">",
	"<",
	">=",
	"<="
]
const SETS = [
	"all_nodes",
	"enemy_nodes",
	"controled_nodes"
]
const TARGETS = [
	"local",
	"random_node",
	"random_enemy",
	"random_controled"
]
const VARS = [
	"number",
	"cpu",
	"control"
]
#const FOR_VARS = [
#	"i","j","k","l","m","n","a","b","c","d","e","f","g","h"
#]
#const MAIN_COMMANDS = [
#	"if","while","for","break","return","sleep","connect","disconnect",
#	"attack","protect","translocate","clone"
#]
const STATEMENT_ARGS = {
	"==":["number","number"],
	"!=":["number","number"],
	">":["number","number"],
	"<":["number","number"],
	">=":["number","number"],
	"<=":["number","number"]
}


class Program:
	var name
	var nodes
	var max_cpu
	var mean_cpu
	var size
	var cost
	var compile_time
	var compile_cpu
	var line
	var icon
	var image
	
	func _init(dict):
		nodes = dict.code
		if dict.has("name"):
			name = dict.name
		if dict.has("icon"):
			icon = "res://images/icons/"+dict.icon+".png"
			image = "res://images/cards/"+dict.icon+".png"
		line = 0
		calc_statistics()
	
	func calc_statistics():
		var time := 0.0
		size = 0
		max_cpu = 0
		mean_cpu = 0
		cost = 0
		compile_cpu = 0
		compile_time = 0
		
		for node in nodes.values():
			var cpu := 0
			var delay := 0.0
			if typeof(Programs.COMMANDS[node.type].cost)==TYPE_STRING:
				cost += Programs.call(Programs.COMMANDS[node.type].cost,node.arguments)
			else:
				cost += Programs.COMMANDS[node.type].cost
			if typeof(Programs.COMMANDS[node.type].size)==TYPE_STRING:
				size += Programs.call(Programs.COMMANDS[node.type].size,node.arguments)
			else:
				size += Programs.COMMANDS[node.type].size
			if typeof(Programs.COMMANDS[node.type].cpu)==TYPE_STRING:
				cpu = Programs.call(Programs.COMMANDS[node.type].cpu,node.arguments)
			else:
				cpu = Programs.COMMANDS[node.type].cpu
			if cpu>max_cpu:
				max_cpu = cpu
			if typeof(Programs.COMMANDS[node.type].delay)==TYPE_STRING:
				delay = Programs.call(Programs.COMMANDS[node.type].delay,node.arguments)
			else:
				delay = Programs.COMMANDS[node.type].delay
			mean_cpu += cpu*delay
			time += delay
			
		compile_cpu = int(3*sqrt(mean_cpu))
		mean_cpu /= max(time,1.0)
		compile_time = time
	

class PrgmNode:
	var type := "initialize"
	var arguments := []
	var dir := []
	var pos := Vector2()
	
	func _init(p,dict):
		pos = pos
		type = dict.type
		if dict.has("dir"):
			dir = dict.dir
		if dict.has("arguments"):
			arguments = dict.arguments
	
	func to_dict():
		return {"type":type,"arguments":arguments,"dir":dir,"pos":pos}


var programs = {
	"anti_virus":{
		"name":"ANTI_VIRUS",
		"code":to_class(ANTI_VIRUS),
		"icon":"anti_virus"
	},
	"pulse":{
		"name":"PULSE",
		"code":to_class(PULSE),
		"icon":"pulse"
	},
	"wave":{
		"name":"WAVE",
		"code":to_class(WAVE),
		"icon":"wave"
	},
	"fire_wall":{
		"name":"FIRE_WALL",
		"code":to_class(FIRE_WALL),
		"icon":"fire_wall"
	},
	"phalanx":{
		"name":"PHALANX",
		"code":to_class(PHALANX),
		"icon":"phalanx"
	},
	"worm":{
		"name":"WORM",
		"code":to_class(WORM),
		"icon":"worm"
	},
	"agent":{
		"name":"AGENT",
		"code":to_class(AGENT),
		"icon":"concentric_red"
	},
}

# warning-ignore:unused_class_variable
var predefined_programs : Array = programs.keys()
var known_programs := {}
var known_commands := []


func get_offset(dir : int,pos : Vector2) -> Vector2:
	var offset := Vector2()
	if dir==0:
		offset = Vector2(1,int(pos.x)%2)
	elif dir==1:
		offset = Vector2(0,1)
	elif dir==2:
		offset = Vector2(-1,int(pos.x)%2)
	elif dir==3:
		offset = Vector2(-1,-int(pos.x+1)%2)
	elif dir==4:
		offset = Vector2(0,-1)
	elif dir==5:
		offset = Vector2(1,-int(pos.x+1)%2)
	return offset

func attack_cpu(args):
	return int(args[0])

func attack_delay(args):
	return 1.0+float(args[0])/2.0

func protect_delay(args):
	return 5.0+float(args[0])


func to_class(code):
	var nodes = {}
	for pos in code.keys():
		nodes[pos] = PrgmNode.new(pos,code[pos])
	return nodes

func to_dict(code):
	var dict = {}
	for pos in code.keys():
		dict[pos] = code[pos].do_dict()
	return dict

func _save(file):
	var dict := {}
	for k in known_programs.keys():
		dict[k] = to_dict(known_programs[k])
	file.store_line(JSON.print({"known_commands":known_commands,"known_programs":dict}))

func _load(file):
	var currentline = JSON.parse(file.get_line()).result
	if currentline!=null:
		known_commands = currentline.known_commands
		known_programs = currentline.known_programs
		# Convert strings to Vector2 as it cannot be loaded poperly.
		for k1 in known_programs.keys():
			var code := {}
			for k2 in known_programs[k1].code.keys():
				var array = k2.split(",")
				if array.size()>=2:
					var pos = Vector2(int(array[0]),int(array[1]))
					code[pos] = known_programs[k1].code[k2]
			known_programs[k1].code = to_class(code)

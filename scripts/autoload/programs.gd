extends Node

# Predefined programs.

const ANTI_VIRUS = [
	"// ANTI_VIRUS_COMMENT_1",
	"while cpu > 5",
		"if control < 100",
			"// ANTI_VIRUS_COMMENT_2",
			"connect local",
			"attack 2",
			"disconnect",
		"end",
		"sleep 2",
	"end",
	"return"
]

const PULSE = [
	"// PULSE_COMMENT_1",
	"while enemy_adjacent",
		"// PULSE_COMMENT_2",
		"connect random_enemy",
		"attack 3",
		"disconnect",
	"end",
	"return"
]

const WAVE = [
	"// WAVE_COMMENT_1",
	"for i in all_nodes",
		"// WAVE_COMMENT_2",
		"connect i",
	"end",
	"// WAVE_COMMENT_3",
	"attack 5",
	"disconnect",
	"return"
]

const FIRE_WALL = [
	"// FIRE_WALL_COMMENT_1",
	"connect local",
	"while hostile_program_adjacent",
		"// FIRE_WALL_COMMENT_2",
		"protect 3",
	"end",
	"disconnect",
	"return"
]

const PHALANX = [
	"// PHALANX_COMMENT_1",
	"while enemy_adjacent",
		"// PHALANX_COMMENT_2",
		"if control < 80",
			"connect local",
			"attack 2",
			"disconnect",
		"end",
		"if hostile_program_adjacent",
			"connect local",
			"protect 2",
			"disconnect",
		"else",
			"connect random_enemy",
			"attack 4",
			"disconnect",
		"end",
		"// PHALANX_COMMENT_3",
		"sleep 2",
	"end",
	"return"
]

const WORM = [
	"// WORM_COMMENT_1",
	"while cpu > 5",
		"while enemy_adjacent",
			"// WORM_COMMENT_2",
			"connect random_enemy",
			"attack 3",
			"disconnect",
		"end",
		"if control > 75",
			"// WORM_COMMENT_3",
			"clone",
		"else",
			"connect local",
			"attack 2",
			"disconnect",
		"end",
		"// WORM_COMMENT_4",
		"connect random_controled",
		"translocate",
		"disconnect",
	"end",
	"return"
]

const AGENT = [
	"// AGENT_COMMENT_1",
	"while controled_adjacent",
		"while enemy_adjacent",
			"// AGENT_COMMENT_2",
			"connect random_enemy",
			"attack 5",
			"disconnect",
		"end",
		"// AGENT_COMMENT_3",
		"connect random_controled",
		"translocate",
		"disconnect",
	"end",
	"return"
]


const COMMANDS = {
	"return":{
		"cpu":0,
		"size":0,
		"cost":0,
		"delay":0,
		"sustained":false},
	"end":{
		"cpu":0,
		"size":0,
		"cost":0,
		"delay":0,
		"sustained":false},
	"continue":{
		"cpu":0,
		"size":0,
		"cost":0,
		"delay":0,
		"sustained":false},
	"break":{
		"cpu":0,
		"size":0,
		"cost":0,
		"delay":0,
		"sustained":false},
	"disconnect":{
		"cpu":0,
		"size":0,
		"cost":0,
		"delay":0.5,
		"sustained":false},
	"connect":{
		"cpu":1,
		"size":1,
		"cost":50,
		"delay":1.0,
		"sustained":"disconnect"},
	"attack":{
		"cpu":"attack_cpu",
		"size":4,
		"cost":100,
		"delay":"attack_delay",
		"sustained":false},
	"protect":{
		"cpu":"attack_cpu",
		"size":3,
		"cost":100,
		"delay":"protect_delay",
		"sustained":false},
	"translocate":{
		"cpu":4,
		"size":4,
		"cost":200,
		"delay":5.0,
		"sustained":false},
	"clone":{
		"cpu":4,
		"size":8,
		"cost":350,
		"delay":2.0,
		"sustained":false},
	"sleep":{
		"cpu":0,
		"size":1,
		"cost":20,
		"delay":1.0,
		"sustained":false},
	"if":{
		"cpu":1,
		"size":1,
		"cost":50,
		"delay":0.0,
		"sustained":"end"},
	"else":{
		"cpu":1,
		"size":1,
		"cost":50,
		"delay":0.0,
		"sustained":"end"},
	"elif":{
		"cpu":1,
		"size":1,
		"cost":50,
		"delay":0.0,
		"sustained":"end"},
	"for":{
		"cpu":1,
		"size":1,
		"cost":75,
		"delay":0.0,
		"sustained":"end"},
	"while":{
		"cpu":1,
		"size":2,
		"cost":100,
		"delay":0.0,
		"sustained":"end"},
	
}

const STATEMENTS = [
	"_true",
	"enemy_adjacent",
	"controled_adjacent",
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
const FOR_VARS = [
	"i","j","k","l","m","n","a","b","c","d","e","f","g","h"
]
const MAIN_COMMANDS = [
	"if","while","for","break","return","sleep","connect","disconnect",
	"attack","protect","translocate","clone"
]

class Program:
	var name
	var code
	var max_cpu
	var mean_cpu
	var lines
	var size
	var cost
	var compile_time
	var compile_cpu
	var line
	var icon
	var image
	
	func _init(dict):
		code = dict.code
		if dict.has("name"):
			name = dict.name
		if dict.has("icon"):
			icon = "res://images/icons/"+dict.icon+".png"
			image = "res://images/cards/"+dict.icon+".png"
		line = 0
		calc_statistics()
	
	func calc_statistics():
		var current_cpu = 0
		var time = 0
		var temp = []
		size = 0
		max_cpu = 0
		mean_cpu = 0
		cost = 0
		lines = 0
		compile_cpu = 0
		compile_time = 0
		
		for i in range(code.size()):
			var type
			var cpu
			var delay
			var line = code[i]
			if "//" in line:
				continue
			
			for c in Programs.COMMANDS.keys():
				if c in line:
					type = c
					break
			if type!=null:
				lines += 1
				if typeof(Programs.COMMANDS[type].cost)==TYPE_STRING:
					cost += Programs.call(Programs.COMMANDS[type].cost,line)
				else:
					cost += Programs.COMMANDS[type].cost
				if typeof(Programs.COMMANDS[type].size)==TYPE_STRING:
					size += Programs.call(Programs.COMMANDS[type].size,line)
				else:
					size += Programs.COMMANDS[type].size
				if typeof(Programs.COMMANDS[type].cpu)==TYPE_STRING:
					cpu = Programs.call(Programs.COMMANDS[type].cpu,line)
				else:
					cpu = Programs.COMMANDS[type].cpu
				if typeof(Programs.COMMANDS[type].delay)==TYPE_STRING:
					delay = Programs.call(Programs.COMMANDS[type].delay,line)
				else:
					delay = Programs.COMMANDS[type].delay
				for j in range(temp.size()):
					for k in temp[j].keys():
						if k==type:
							current_cpu -= temp[j][k]
							temp[j].erase(k)
				if typeof(cpu)==TYPE_INT || typeof(cpu)==TYPE_REAL:
					if current_cpu+cpu>max_cpu:
						max_cpu = current_cpu+cpu
					mean_cpu += (current_cpu+cpu)*delay
					compile_cpu += cpu
				time += delay
				if typeof(Programs.COMMANDS[type].sustained)==TYPE_STRING:
					current_cpu += cpu
					temp.push_back({Programs.COMMANDS[type].sustained:cpu})
				elif Programs.COMMANDS[type].sustained:
					current_cpu += cpu
		mean_cpu /= max(time,1)
		compile_cpu = int(3*sqrt(compile_cpu))
		compile_time = time
	


var programs = {
	"anti_virus":{
		"name":"ANTI_VIRUS",
		"code":ANTI_VIRUS,
		"icon":"anti_virus"
	},
	"pulse":{
		"name":"PULSE",
		"code":PULSE,
		"icon":"pulse"
	},
	"wave":{
		"name":"WAVE",
		"code":WAVE,
		"icon":"wave"
	},
	"fire_wall":{
		"name":"FIRE_WALL",
		"code":FIRE_WALL,
		"icon":"fire_wall"
	},
	"phalanx":{
		"name":"PHALANX",
		"code":PHALANX,
		"icon":"phalanx"
	},
	"worm":{
		"name":"WORM",
		"code":WORM,
		"icon":"worm"
	},
	"agent":{
		"name":"AGENT",
		"code":AGENT,
		"icon":"concentric_red"
	},
}

# warning-ignore:unused_class_variable
var predefined_programs : Array = programs.keys()
var known_programs := {}
var known_commands := []


func attack_cpu(line):
	var array = line.split(" ",false)
	if array.size()>1:
		return str2var(array[1])
	else:
		return 1.0

func attack_delay(line):
	var array = line.split(" ",false)
	if array.size()>1 && (typeof(array[1])==TYPE_INT || typeof(array[1])==TYPE_REAL):
		return 1.0+str2var(array[1])
	else:
		return 1.0

func protect_delay(line):
	var array = line.split(" ",false)
	if array.size()>1 && (typeof(array[1])==TYPE_INT || typeof(array[1])==TYPE_REAL):
		return 5.0+str2var(array[1])
	else:
		return 5.0


func _save(file):
	file.store_line(JSON.print({"known_commands":known_commands,"known_programs":known_programs}))

func _load(file):
	var currentline = JSON.parse(file.get_line()).result
	if currentline!=null:
		known_commands = currentline.known_commands
		known_programs = currentline.known_programs
	

extends Node

var upgrades := {}


func inc_cpu(inc : int):
	Objects.actors.player.cpu += inc

func inc_memory(inc : int):
	Objects.actors.player.memory += inc

func inc_time_limit(inc : int):
	Objects.actors.player.time_limit += inc

func inc_compiler_cpu(inc : int):
	Objects.actors.ai.cpu += inc


# definitions #

func _ready():
	upgrades["cpu"] = {"name":"CPU","method":"inc_cpu","args":3,
		"cost":2000,"compile_time":20.0,"compile_cpu":10,
		"icon":"res://images/icons/cpu.png","image":"res://images/cards/cpu.png"}
	upgrades["memory"] = {"name":"MEMORY","method":"inc_memory","args":16,
		"cost":1500,"compile_time":15.0,"compile_cpu":10,
		"icon":"res://images/icons/memory.png","image":"res://images/cards/memory.png"}
	upgrades["time_limit"] = {"name":"TIME_LIMIT","method":"inc_time_limit","args":5.0,
		"cost":1500,"compile_time":30.0,"compile_cpu":5,
		"icon":"res://images/icons/memory.png","image":"res://images/cards/memory.png"}
	upgrades["compile_cpu"] = {"name":"COMPILER_CPU","method":"inc_compiler_cpu","args":4,
		"cost":750,"compile_time":10.0,"compile_cpu":10,
		"icon":"res://images/icons/cpu.png","image":"res://images/cards/cpu.png"}
	

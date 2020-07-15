extends Node

# Upgrade definitions #

const upgrades := {
	"cpu":{"name":"CPU","method":"inc_cpu","args":3,
		"cost":2000,"compile_time":20.0,"compile_cpu":10,
		"icon":"res://images/icons/cpu.png","image":"res://images/cards/cpu.png"
	},
	"memory":{"name":"MEMORY","method":"inc_memory","args":32,
		"cost":2000,"compile_time":15.0,"compile_cpu":10,
		"icon":"res://images/icons/memory.png","image":"res://images/cards/memory.png"
	},
	"time_limit":{"name":"TIME_LIMIT","method":"inc_time_limit","args":5.0,
		"cost":1500,"compile_time":30.0,"compile_cpu":5,
		"icon":"res://images/icons/memory.png","image":"res://images/cards/memory.png"
	},
	"compile_cpu":{"name":"COMPILER_CPU","method":"inc_compiler_cpu","args":4,
		"cost":750,"compile_time":10.0,"compile_cpu":10,
		"icon":"res://images/icons/cpu.png","image":"res://images/cards/cpu.png"
	},
	"ai_server":{"name":"AI_SERVER","method":"inc_ai","args":1,
		"cost":10000,"compile_time":120.0,"compile_cpu":5,
		"icon":"res://images/icons/cpu.png","image":"res://images/cards/tpu.png"
	}
}

# Do upgrades #

func inc_cpu(inc : int):
	Objects.actors.player.cpu += inc

func inc_memory(inc : int):
	Objects.actors.player.memory += inc

func inc_time_limit(inc : int):
	Objects.actors.player.time_limit += inc

func inc_compiler_cpu(inc : int):
	Objects.actors.ai.cpu += inc

func inc_ai(inc : int):
	Vars.inc_var("ai_upgrade",inc)

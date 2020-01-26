extends Node

var vars := {}

func save_var(n,v=true):
	vars[n] = v

func inc_var(n):
	if vars.has(n) && (typeof(vars[n])==TYPE_INT || typeof(vars[n])==TYPE_REAL):
		vars[n] += 1
	else:
		vars[n] = 1

func get_var(n):
	if vars.has(n):
		return vars[n]
	else:
		return

func _save(file):
	file.store_line(JSON.print(vars))

func _load(file):
	var currentline = JSON.parse(file.get_line()).result
	if currentline!=null:
		vars = currentline

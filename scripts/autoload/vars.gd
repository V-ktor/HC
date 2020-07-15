extends Node

var vars := {}

func save_var(n,v=true):
	vars[n] = v

func clear_var(n):
	vars.erase(n)

func inc_var(n,delta=1):
	if vars.has(n) && (typeof(vars[n])==TYPE_INT || typeof(vars[n])==TYPE_REAL):
		vars[n] += delta
	else:
		vars[n] = delta

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

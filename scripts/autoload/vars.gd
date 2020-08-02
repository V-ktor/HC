extends Node

var vars := {}
var messages := []

class MsgSorter:
	static func sort_ascending(a,b):
		for i in range(min(a.name.length(),b.name.length())):
			if a.name[i]<b.name[i]:
				return true
			if a.name[i]!=b.name[i]:
				return false
		return a.name.length()<b.name.length()


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

func add_message(name,text):
	messages.push_back({"name":name,"text":text})
	messages.sort_custom(MsgSorter,"sort_ascending")

func _save(file):
	file.store_line(JSON.print(vars))
	file.store_line(JSON.print(messages))

func _load(file):
	var currentline = JSON.parse(file.get_line()).result
	if currentline!=null:
		vars = currentline
	currentline = JSON.parse(file.get_line()).result
	if currentline!=null:
		messages = currentline

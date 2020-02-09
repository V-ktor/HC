extends Control

var pos := Vector2()

func can_drop_data(position,data):
	return typeof(data)==TYPE_VECTOR2 && Menu.program_nodes.has(data)

func drop_data(position,data):
	if !Menu.program_nodes.has(data):
		Menu.update_program()
		return
	var node = Menu.program_nodes[data]
	Menu.program_nodes.erase(data)
	Menu.program_nodes[pos] = node
	Menu.update_program()

func _gui_input(event):
	if event is InputEventMouseButton && event.doubleclick:
		Menu.add_prg_node(pos)

func _ready():
	connect("gui_input",self,"_gui_input")

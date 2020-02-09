extends Control

var initial_pos := Vector2()
onready var scroll_container := get_parent()

func _gui_input(event):
	if event.is_action_pressed("screen_drag"):
		initial_pos = event.position
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("screen_drag"):
			var offset = initial_pos-event.position
			offset.x = round(offset.x)
			offset.y = round(offset.y)
			scroll_container.scroll_horizontal += offset.x
			scroll_container.scroll_vertical += offset.y
			initial_pos -= offset
#	elif event is InputEventMouseButton:
#		if event.doubleclick:
#			var pos = event.position/Vector2(172,196)
#			pos.x = round(pos.x)
#			pos.y = round(pos.y)
#			printt(pos)
#			get_node("../../../../").add_prg_node(pos)
	

func _ready():
	connect("gui_input",self,"_gui_input")

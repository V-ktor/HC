extends TextureRect

var initial_pos := Vector2()
onready var camera := $Viewport/Camera


#func _gui_input(event):
#	if event.is_action_pressed("screen_drag"):
#		initial_pos = event.position
#	if event is InputEventMouseMotion && Input.is_action_pressed("screen_drag"):
#		camera.position += initial_pos-event.position
#		initial_pos = event.position
#	

func _ready():
#	connect("gui_input",self,"_gui_input")
	pass

extends Control

var initial_pos := Vector2()
onready var scroll_container := get_parent()


func _input(event):
	if event.is_action_pressed("screen_drag"):
		initial_pos = event.position
	if event is InputEventMouseMotion && !get_viewport().gui_is_dragging():
		if Input.is_action_pressed("screen_drag"):
			var offset = initial_pos-event.position
			offset.x = round(offset.x)
			offset.y = round(offset.y)
			scroll_container.scroll_horizontal += offset.x
			scroll_container.scroll_vertical += offset.y
			initial_pos -= offset

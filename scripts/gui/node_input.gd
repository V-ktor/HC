extends Node2D


func _input(event):
	if (event is InputEventMouseButton) && event.button_index==1 && event.pressed:
		var cam = $"../../../Camera"
		var pos = get_global_position()/cam.zoom-cam.get_camera_screen_center()/cam.zoom+OS.window_size/2
		if event.position.distance_squared_to(pos)<64*64:
			$"../../../".select($"../".ID)

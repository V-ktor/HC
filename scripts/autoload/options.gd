extends Node

var fullscreen := true
var window_maximized := false
var resolution := OS.get_screen_size(OS.current_screen)
var target_fps := 0
var show_particles := true
var disable_screen_shader := false
var music_volume := 1.0
var sound_volume := 1.0


func apply_settings():
	OS.window_size = resolution
	OS.window_maximized = window_maximized
	OS.window_fullscreen = fullscreen
	Engine.target_fps = target_fps
	AudioServer.set_bus_volume_db(1,linear2db(music_volume))
	AudioServer.set_bus_volume_db(2,linear2db(sound_volume))


func _save():
	var file := File.new()
	var error := file.open("user://config.cfg",File.WRITE)
	if error!=OK:
		print("Error (code "+str(error)+") while creating config file!")
		return
	
	file.store_line(JSON.print({
		"fullscreen":fullscreen,
		"window_maximized":window_maximized,
		"resolution_x":resolution.x,
		"resolution_y":resolution.y,
		"target_fps":target_fps,
		"show_particles":show_particles,
		"disable_screen_shader":disable_screen_shader,
		"music_volume":music_volume,
		"sound_volume":sound_volume
	}))
	file.close()

func _load():
	var file := File.new()
	var error := file.open("user://config.cfg",File.READ)
	if error!=OK:
		print("Error (code "+str(error)+") while opening config file!")
		apply_settings()
		return
	
	var currentline = JSON.parse(file.get_line()).result
	if currentline!=null:
		fullscreen = currentline.fullscreen
		window_maximized = currentline.window_maximized
		resolution = Vector2(currentline.resolution_x,currentline.resolution_y)
		target_fps = currentline.target_fps
		show_particles = currentline.show_particles
		disable_screen_shader = currentline.disable_screen_shader
		music_volume = currentline.music_volume
		sound_volume = currentline.sound_volume
	file.close()
	apply_settings()

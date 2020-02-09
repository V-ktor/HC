tool
extends RichTextEffect

var bbcode = "matrix"

func _process_custom_fx(char_fx):
	if fmod(char_fx.elapsed_time+0.25*char_fx.absolute_index*sin(char_fx.elapsed_time),0.5)<0.1:
		char_fx.character = 64+randi()%26
	return true

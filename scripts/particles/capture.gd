extends Node2D


func _ready():
	$Sprite.rotation = 2.0*PI*randf()

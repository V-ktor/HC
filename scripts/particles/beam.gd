extends Node2D

var node
var target


func cancel():
	$AnimationPlayer.play("vanish")

func _ready():
	position = node.position
	look_at(target.position)
	scale.x = node.position.distance_to(target.position)/200.0
	$Impact.set_global_position(target.position)

extends Node2D

var node


func cancel():
	$AnimationPlayer.play("vanish")

func timeout():
	$AnimationPlayer.play("vanish")

func _ready():
	position = node.position

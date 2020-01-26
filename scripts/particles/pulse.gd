extends Node2D

var from
var to
var duration

var particles = preload("res://scenes/particles/impact.tscn")


func timeout():
	var pi = particles.instance()
	$AnimationPlayer.play("hit")
	pi.position = position
	get_parent().add_child(pi)

func cancel():
	$AnimationPlayer.play("hit")

func _ready():
	$Tween.interpolate_property(self,"position",from.position,to.position,duration,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	position = from.position
	look_at(to.position)
	$Tween.start()
	$Particles.process_material = $Particles.process_material.duplicate()
	$Particles.process_material.angle = rotation_degrees

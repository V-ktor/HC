extends Node2D

var from
var to
var duration


func timeout():
	$AnimationPlayer.play("fade_out")

func cancel():
	$AnimationPlayer.play("fade_out")

func _process(_delta):
	$Sprite.material.set_shader_param("wavelength",1.0/2.0/scale.x)

func _ready():
	$Sprite.material = $Sprite.material.duplicate()
	position = from.position
	look_at(to.position)
	$Tween.interpolate_property(self,"scale",Vector2(0.1,1.0),Vector2(from.position.distance_to(to.position)/96.0,1.0),duration,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.start()

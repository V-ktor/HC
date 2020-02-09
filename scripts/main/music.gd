extends Node

const DEFAULT = ["bazaarnet.ogg","crystal_space.ogg","restoration_completed.ogg","simulation_unknown.ogg"]
const ACTION = ["caves.ogg","currents.ogg","test_subject.ogg","tribal_chaos.ogg","wicked_beast.ogg"]

onready var player = $Audio
onready var animation = $AnimationPlayer


func play(file:String,dB:=0.0):
	var stream = load("res://music/"+file)
	if player.playing:
		animation.play("fade_out")
		yield(animation,"animation_finished")
	player.stream = stream
	player.volume_db = dB
	player.play()

func stop():
	if player.playing:
		animation.play("fade_out")
		yield(animation,"animation_finished")
	player.stop()

func play_default():
	play(DEFAULT[randi()%DEFAULT.size()])

func play_action():
	play(ACTION[randi()%ACTION.size()])


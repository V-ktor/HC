extends Control

var pos := Vector2()
var rot := 0
var entries := []
var rotation := 0.0
var disabled := false


func fade_out():
	$AnimationPlayer.play("fade_out")

func _process(delta):
	rect_rotation += 10.0*delta*(rotation-rect_rotation)

func _rotate():
	if disabled:
		return
	rotation += 60.0
	rot = (rot+1)%6
	Menu.update_decryption()

func update_text():
	for i in range(entries.size()):
		get_node("Label"+str(i+1)).text = entries[i]

func _ready():
	entries.resize(6)
	for i in range(entries.size()):
		entries[i] = ""
	connect("pressed",self,"_rotate")

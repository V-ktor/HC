extends Panel

var pos0
var node


func _draw():
	draw_line(rect_size/2,rect_size/2*rect_scale-pos0/$"../../../Camera".zoom,self_modulate,4,true)

func _process(_delta):
	rect_position = (pos0+node.position-$"../../../Camera".get_camera_screen_center())/$"../../../Camera".zoom+OS.window_size/2-rect_size/2*rect_scale
	update()

func _ready():
	pos0 = rect_position

extends TextureRect

const SPEED = 50.0
var initial_position : Vector2
var pos := Vector2()
var dir := []
var dragged := false
var scale := 1.0


func get_drag_data(position):
	dragged = true
	mouse_filter = MOUSE_FILTER_IGNORE
	raise()
	set_drag_preview(self)
	return pos

func _process(delta):
	var move_to = initial_position
	scale += delta*10.0*(1.0-0.25*float(dragged)-scale)
	rect_scale = Vector2(scale,scale)
	if dragged:
		move_to = get_parent().get_local_mouse_position()-rect_size/2.0
	rect_position += delta*SPEED*(move_to-rect_position)
	$PopupMenu.rect_global_position = rect_global_position+rect_size/2-$PopupMenu.rect_size/2

func _input(event):
	if event is InputEventMouseButton && !event.pressed:
		dragged = false
		mouse_filter = MOUSE_FILTER_STOP

func _gui_input(event):
	if event is InputEventMouseButton && event.pressed:
		if event.button_index==1:
			$PopupMenu.hide()
			for i in range(dir.size()):
				var arrow_pos := Vector2(80,0).rotated(get_node("Arrow"+str(i)).rotation)+rect_size/2.0
				if event.position.distance_squared_to(arrow_pos)<32.0*32.0:
					Menu.prog_rotate(pos,i)
		elif event.button_index==2:
			$PopupMenu.show()

func _menu_pressed(ID):
	if ID==0:
		Menu.rm_prg_node(pos)

func _ready():
	connect("gui_input",self,"_gui_input")
	$PopupMenu.connect("id_pressed",self,"_menu_pressed")
	initial_position = rect_position

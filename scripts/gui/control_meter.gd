extends Control


func _draw():
	var total_nodes = $"../../../".points.size()
	var total_control = []
	var total_owned = []
	var num_players = $"../../../".num_players
	var control_sum = 0
	var rn = 0
	var pos = 0.0
	var pos2 = 0.0
	total_control.resize(num_players)
	total_owned.resize(num_players)
	for i in range(num_players):
		total_control[i] = 0.0
		total_owned[i] = 0.0
	
	for p in $"../../../".points:
		for i in range(num_players):
			total_control[i] += p.control[i]
		if p.owner>=0:
			total_owned[p.owner] += 1
	
	for p in range(num_players):
		control_sum += total_control[p]
		rn += total_owned[p]
	control_sum *= total_nodes/rn
	
	for i in range(num_players):
		var width = total_control[i]/control_sum*rect_size.x
		var width2 = total_owned[i]/total_nodes*rect_size.x
		draw_rect(Rect2(pos,0,width,32),$"../../../".colors[i])
		draw_rect(Rect2(pos2,0,width2,32),Color($"../../../".colors[i].r,$"../../../".colors[i].g,$"../../../".colors[i].b,0.5))
		pos += width
		pos2 += width2
	draw_rect(Rect2(pos,0,max(rect_size.x-pos,0),32),Color(0.0,0.0,0.0))

func _process(_delta):
	update()

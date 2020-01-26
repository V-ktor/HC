extends Node2D


func _draw():
	for p in $"../".points:
		for ID in p.connections:
			draw_line(p.position,$"../".points[ID].position,Color(1.0,1.0,1.0,0.5),8,true)

extends Camera2D

var z = 2.0


func _process(delta):
	var z0 = (zoom.x+zoom.y)/2.0
	zoom = Vector2(1.0,1.0)*(z0+4.0*delta*(z-z0))

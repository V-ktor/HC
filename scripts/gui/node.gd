extends Node

var ID = -1


func _process(_delta):
	if ID>=0:
		var c1 = 0
		var c2 = 0
		var owner = -1
		for i in range(min($"../../".num_players,3)):
#			get_node("Control"+str(i+1)).value = $"../../".points[ID].control[i]
			if $"../../".points[ID].control[i]>c1:
				c1 = $"../../".points[ID].control[i]
				owner = i
			elif $"../../".points[ID].control[i]>c2:
				c2 = $"../../".points[ID].control[i]
		$Control.value = 2*(c1-max(c2,50))
		if $Control.value<=0:
			$Control1.value = c1
		else:
			$Control1.value = 0
		if owner>=0:
			$Control.modulate = $"../../".colors[owner].lightened(0.2)
			$Control1.modulate = $"../../".colors[owner].lightened(0.2)
			$Text.self_modulate = $"../../".colors[owner]
		else:
			$Control.modulate = Color(1.0,1.0,1.0)
			$Text.self_modulate = Color(1.0,1.0,1.0)

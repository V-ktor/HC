extends Node


func update_prgms():
	var index := 1
	for c in $Panel/VBoxContainer/ScrollContainer/VBoxContainer.get_children():
		c.hide()
	for node in $"../".points:
		for prgm in node.programs:
			if prgm.owner==0:
				var item
				if has_node("Panel/VBoxContainer/ScrollContainer/VBoxContainer/Prgm"+str(index)):
					item = get_node("Panel/VBoxContainer/ScrollContainer/VBoxContainer/Prgm"+str(index))
				else:
					item = $Panel/VBoxContainer/ScrollContainer/VBoxContainer/Prgm1.duplicate()
					item.name = "Prgm"+str(index)
					$Panel/VBoxContainer/ScrollContainer/VBoxContainer.add_child(item)
				item.get_node("Label").text = tr(Programs.programs[prgm.type].name)
				item.get_node("Number").text = str(prgm.cpu)
				item.show()
				index += 1
		
	

func _process(_delta):
	$Panel/VBoxContainer/CPU.value = $"../".cpu[0]
	$Panel/VBoxContainer/CPU.max_value = $"../".max_cpu[0]
	$Panel/VBoxContainer/CPU/Label.text = str($"../".cpu[0])+"/"+str($"../".max_cpu[0])

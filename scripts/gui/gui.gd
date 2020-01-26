extends Node


func _process(_delta):
	$Panel/VBoxContainer/CPU.value = $"../".cpu[0]
	$Panel/VBoxContainer/CPU.max_value = $"../".max_cpu[0]
	$Panel/VBoxContainer/CPU/Label.text = str($"../".cpu[0])+"/"+str($"../".max_cpu[0])

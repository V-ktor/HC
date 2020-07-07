extends Control

var buffer := []
var text := ""
var delay := 0.0

onready var label := $Panel/Label
onready var portrait := $Portrait/Portrait
onready var animation := $AnimationPlayer

# Emitted when the text box is closed.
signal closed


func show_text(txt:String,clear:=true,prt=null):
	# Display some text.
	# Open the text box if not visible or currently collapsing.
	if buffer.size()==0 || (animation.is_playing() && animation.current_animation=="collapse") || visible:
		$Progress.hide()
		$Idle.hide()
		animation.queue("expand")
	buffer.push_back({"text":tr(txt),"portrait":prt,"clear":clear})
	delay = 0.0

func set_portrait(path:String):
	# Change the portrait shown in the text box.
	portrait.texture = load(path)

func _process(delta):
	delay -= delta
	
	if delay<=0.0:
		if text.length()>0:
			# Print text, one char at a time.
			label.text += text[0]
			text = text.substr(1,text.length()-1)
			if text.length()==0 && (buffer.size()==0 || buffer[0].clear):
				# All text written.
				$Progress.hide()
				$Idle.show()
				$AnimationPlayer2.play("idle")
				delay = 10.0
			else:
				# Writing...
				$Progress.show()
				$Idle.hide()
				if $AnimationPlayer2.current_animation!="progress":
					$AnimationPlayer2.play("progress")
				delay = 0.02
		elif buffer.size()>0:
			# Next page.
			text = buffer[0].text
			if buffer[0].clear:
				label.text = ""
			else:
				label.text += "\n"
			buffer.pop_front()
			delay = 0.5
		elif !animation.is_playing() && visible:
			# Hide text box.
			$Progress.hide()
			$Idle.hide()
			animation.play("collapse")
			delay = 0.6
			emit_signal("closed")

func _input(event):
	if event is InputEventMouseButton && event.pressed:
		# Next page.
		delay = 0.0

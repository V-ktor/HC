extends Node

var delayed := []
var triggered := []
var chats := {}
var logs := []


func get_largest_msg_delay(actor=null):
	var delay = 0.0
	for dict in delayed:
		if actor==null || (dict.method in ["send_msg","send_player_msg","add_choice"] && dict.args[0]==actor):
			delay = max(delay,dict.delay)
	return delay

func delayed_msg(from,text,delay):
	delayed.push_back({"delay":delay+get_largest_msg_delay(from),"method":"send_msg","args":[from,text]})

func delayed_player_msg(contact,text,delay):
	delayed.push_back({"delay":delay+get_largest_msg_delay(contact),"method":"send_player_msg","args":[contact,text]})

func delayed_hack_msg(text,delay,from_player=false):
	delayed.push_back({"delay":delay+get_largest_msg_delay(),"method":"send_hack_msg","args":[text,from_player]})

func delayed_choice(contact,choices,delay):
	delayed.push_back({"delay":delay+get_largest_msg_delay(contact),"method":"add_choice","args":[contact,choices]})

func delayed_method(delay,method,args=[]):
	delayed.push_back({"delay":delay,"method":method,"args":args})

func triggered_msg(from,text,event):
	triggered.push_back({"event":event,"method":"send_msg","actor":from,"args":[from,text]})

func triggered_choice(contact,choices,event):
	triggered.push_back({"event":event,"method":"add_choice","actor":contact,"args":[contact,choices]})

func triggered_method(event,method,args=[],actor=null):
	triggered.push_back({"event":event,"method":method,"actor":actor,"args":args})

func send_msg(from,text):
#	Menu.add_msg(from,tr(Objects.actors[from].name)+": "+text)
	Menu.add_msg(from,text)

func send_player_msg(to,text):
#	Menu.add_msg(to,tr(Objects.actors["player"].name)+": "+text,true)
	Menu.add_msg(to,text,true)

func send_hack_msg(text,from_player=false):
	Menu.add_hack_msg(text,from_player)

func add_choice(contact,choices):
	Menu.add_choice(contact,choices)

func remove_choice(contact,choices):
	Menu.remove_choice(contact,choices)

func _save(file):
	file.store_line(JSON.print({"delayed_events":delayed,"triggered_events":triggered,"logs":logs}))

func _load(file):
	var currentline = JSON.parse(file.get_line()).result
	delayed = currentline.delayed_events
	triggered = currentline.triggered_events
	logs = currentline.logs

func _process(delta):
	for i in range(delayed.size()-1,-1,-1):
		delayed[i]["delay"] -= delta
		if delayed[i]["delay"]<=0.0:
			callv(delayed[i]["method"],delayed[i]["args"])
			delayed.remove(i)



func call_chat(actor,method,args=[]):
	if chats.has(actor):
		chats[actor].callv(method,args)
	else:
		var si = load("res://scripts/chats/"+actor+".gd").new()
		chats[actor] = si
		add_child(si)
		si.callv(method,args)

func trigger(event,args=[]):
	for dict in triggered:
		if dict["event"]==event:
			if dict.has("actor"):
				call_chat(dict.actor,dict.method,args+dict.args)
			else:
				call(dict.method,args+dict.args)
			triggered.erase(dict)

func _on_hack_started(target):
	trigger("on_hack_started",[target])

func _on_hack_ended(victory,target):
	trigger("on_hack_ended",[victory,target])
	if victory:
		trigger("on_hack_success",[target])
	else:
		trigger("on_hack_failed",[target])

func _on_create_hack_files(target,files):
	trigger("on_create_hack_files",[target,files])

func _on_show_chat():
	trigger("on_show_chat")

func _on_show_upgrades():
	trigger("on_show_upgrades")

func _on_show_compile():
	trigger("on_show_compile")

func _on_show_code():
	trigger("on_show_code")

func _on_gained_tech(tech):
	trigger("on_gained_tech",[tech])

func _on_decompile(prgm):
	trigger("on_decompile",[prgm])



# Events #

func start():
	Menu.textbox.set_portrait("res://images/gui/portraits/AI.png")
	Menu.textbox.show_text(tr("AI_0001"))
	Menu.textbox.show_text(tr("AI_0002").replace("<name>",Objects.actors.player.name),false)
	Menu.textbox.show_text(tr("AI_0003"))
	triggered_method("on_show_chat","ai_chat01",[],"ai")

func show_web():
	Menu.get_node("Left/ScrollContainer/VBoxContainer/Button8").show()

func show_upgrades():
	Menu.get_node("Left/ScrollContainer/VBoxContainer/Button7").show()

func show_compile():
	Menu.get_node("Left/ScrollContainer/VBoxContainer/Button5").show()
	Menu.get_node("Left/ScrollContainer/VBoxContainer/Button6").show()

func show_code():
	Menu.get_node("Left/ScrollContainer/VBoxContainer/Button9").show()

func allow_scan():
	Menu.can_scan = true
	if Menu.get_node("Targets").visible:
		Menu._show_targets()

func add_npc1():
	var c = Objects.Actor.new("",Color(0.5,0.4,0.05),"","res://scenes/gui/chat_bg/crypto.tscn",30,150,60.0,{"wave":16,"phalanx":6},0,0,128,{},0)
	Objects.actors["crypto"] = c
	Menu.contacts.push_back("crypto")

func failed_communication_attempt():
	Menu.textbox.set_portrait("res://images/gui/portraits/AI.png")
	Menu.textbox.show_text(tr("AI_0350"))
	Menu.textbox.show_text(tr("AI_0351"))
	Menu.textbox.show_text(tr("AI_0352"))
	Menu.textbox.show_text(tr("AI_0353"))
	


func _remove_target(victory):
	if victory:
		Objects.remove_target(Menu.target_selected)

func _remove_opt_target(_victory):
	Objects.remove_opt_target(Menu.target_selected)



func _local_server_hack(victory):
	call_chat("ai","_local_server_hack",[victory])

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

func delayed_msg(from:String,text:String,delay:float,dict:={}):
	delayed.push_back({"delay":delay+get_largest_msg_delay(from),"method":"send_msg","args":[from,text,dict]})

func delayed_player_msg(contact:String,text:String,delay:float,dict:={}):
	delayed.push_back({"delay":delay+get_largest_msg_delay(contact),"method":"send_player_msg","args":[contact,text,dict]})

func delayed_hack_msg(text:String,delay:float,from_player:=false):
	delayed.push_back({"delay":delay+get_largest_msg_delay(),"method":"send_hack_msg","args":[text,from_player]})

func delayed_choice(contact:String,choices:Array,delay:float):
	delayed.push_back({"delay":delay+get_largest_msg_delay(contact),"method":"add_choice","args":[contact,choices]})

func delayed_method(delay:float,method:String,args:=[]):
	delayed.push_back({"delay":delay,"method":method,"args":args})

func triggered_msg(from:String,text:String,event:String):
	triggered.push_back({"event":event,"method":"send_msg","actor":from,"args":[from,text]})

func triggered_choice(contact:String,choices:Array,event:String):
	triggered.push_back({"event":event,"method":"add_choice","actor":contact,"args":[contact,choices]})

func triggered_method(event:String,method:String,args:=[],actor=null):
	triggered.push_back({"event":event,"method":method,"actor":actor,"args":args})

func send_msg(from:String,text:String,dict:={}):
	Menu.add_msg(from,text,false,dict)

func send_player_msg(to:String,text:String,dict:={}):
	Menu.add_msg(to,text,true,dict)

func send_hack_msg(text:String,from_player:=false):
	Menu.add_hack_msg(text,from_player)

func add_choice(contact:String,choices:Array):
	Menu.add_choice(contact,choices)

func remove_choice(contact:String,choices:String):
	Menu.remove_choice(contact,choices)

func _save(file:File):
	file.store_line(JSON.print({"delayed_events":delayed,"triggered_events":triggered,"logs":logs}))

func _load(file:File):
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

func _on_show_decrypt():
	trigger("on_show_decrypt")

func _on_gained_tech(tech):
	trigger("on_gained_tech",[tech])

func _on_decompile(prgm):
	trigger("on_decompile",[prgm])

func _on_decrypted(dict):
	trigger("on_decrypted",[dict])


# Events #

func start():
	Menu.textbox.set_portrait("res://images/gui/portraits/AI.png")
	Menu.textbox.show_text(tr("AI_0001"))
	Menu.textbox.show_text(tr("AI_0002").format({"name":Objects.actors.player.name}),false)
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

func show_decrypt():
	Menu.get_node("Left/ScrollContainer/VBoxContainer/Button13").show()

func allow_scan():
	Menu.can_scan = true
	if Menu.get_node("Targets").visible:
		Menu._show_targets()

func _local_server_hack(victory):
	call_chat("ai","_local_server_hack",[victory])

func add_npc1():
	var c = Objects.Actor.new("Crypto Maniac",Color(0.5,0.4,0.05),"res://scenes/portraits/crypto.tscn","res://scenes/gui/chat_bg/crypto.tscn",30,150,60.0,{"wave":16,"phalanx":6},0,0,128,{},0)
	Objects.actors.crypto = c
	Menu.contacts.push_back("crypto")
	call_chat("crypto","chat01")
	if Menu.get_node("Chat").visible:
		Menu._show_chat()

func failed_communication_attempt():
	Menu._close(true)
	Menu.add_log_msg("LOG_CONTACT_OLD_FRIEND","LOG_CONTACT_OLD_FRIEND_FAILURE")
	Menu.textbox.set_portrait("res://images/gui/portraits/AI.png")
	Menu.textbox.show_text(tr("AI_0350").format({"name":Objects.actors.player.name}))
	Menu.textbox.show_text(tr("AI_0351"))
	Menu.textbox.show_text(tr("AI_0352"))
	Menu.textbox.show_text(tr("AI_0353"))
	
	call_chat("crypto","chat02")

func set_crypto_hally_talk():
	Menu.chat_add_portrait["crypto"] = "ai"
	if !Menu.get_node("Chat").visible:
		Menu._show_chat()
	Menu._select_contact("crypto")

func failed_communication_attempt2():
	Menu.chat_add_portrait.erase("crypto")
	call_chat("ai","failed_call")

func under_attack():
	call_chat("ai","under_attack")

func add_riley():
	var c = Objects.Actor.new("???",Color(0.4,0.02,0.01),"res://scenes/portraits/character02.tscn","res://scenes/gui/chat_bg/riley.tscn",35,175,50.0,{"pulse":3,"phalanx":3,"scythe":6,"parry":4,"lock":3},0,0,8,{},0)
	Objects.actors.riley = c
	Menu.contacts.push_back("riley")
	call_chat("riley","chat01")
	Menu.add_log_msg("LOG_UNDER_ATTACK","LOG_INTRUDER")
	if Menu.get_node("Chat").visible:
		Menu._show_chat()

func add_riley_local_server():
	var mi = Menu.main_scene.instance()
	var target = Objects.add_target("local_server",tr("YOUR_SERVER").format({"name":Objects.actors.player.name}),null,"127.0.0.1",Color(0.6,0.05,0.04),"layered",[4,4,18],Objects.actors.riley.programs.duplicate(),Objects.actors.riley.cpu,Objects.actors.riley.time_limit+20.0,"ai_random",2500,25,"_local_server_defence")
	target.music_overwrite = "Of_Far_Different_Nature-Escape-14-Crypt.ogg"
	triggered_method("on_hack_started","_riley_defence_start",[],"ai")
	Menu.add_log_msg("LOG_DEFENCE","LOG_DEFENCE_HACK")
	get_tree().get_root().add_child(mi)
	Menu.game_instance = mi
	Menu._show_hack()
	mi.start(2,25.0,[Objects.actors["player"].cpu,30],[Objects.actors["player"].programs,Objects.actors["riley"].programs.duplicate()],["human","ai_random"],[Objects.actors["player"].color,Color(0.6,0.05,0.04)],mi.callv("create_layered_system",[4,3,14]))
	Music.play("Of_Far_Different_Nature-Escape-14-Crypt.ogg")
	if !Options.disable_screen_shader:
		for c in Menu.get_node("Hack/Panel/Portrait").get_children():
			c.queue_free()
		for c in Menu.get_node("Hack/Panel/ScrollContainer/VBoxContainer").get_children():
			c.queue_free()
		yield(get_tree(),"idle_frame")
		Menu.get_node("Boss/AnimationPlayer").play("boss")
		Menu.hack_contact_overwrite = "riley"
		Menu.update_hack_chat()
		Menu.get_node("Hack/Panel").self_modulate.a = 0.0
		Menu.get_node("Hack/Panel").show()
		Menu.get_node("Boss/AnimationPlayer").connect("animation_finished",Menu,"hide_hack_panel",[],CONNECT_ONESHOT)
	yield(mi,"timeout")
	if !Options.disable_screen_shader:
		Menu.get_node("Glitch/AnimationPlayer").play("burst_off")
	mi.queue_free()

func _local_server_defence(victory):
	if victory:
		if !Objects.actors.player.programs.has("lock"):
			Objects.actors.player.programs["lock"] = 1
			Menu.add_log_msg(tr("LOG_NEW_PROGRAM_ACQUIRED").format({"name":tr(Programs.programs["lock"].name)}),tr("LOG_NEW_PROGRAM_ACQUIRED").format({"name":tr(Programs.programs["lock"].name)}))
		else:
			Objects.actors.player.programs["lock"] += 1
		Menu.get_node("Hack/Result/LabelReward").text += tr("TECHS")+": "+tr(Programs.programs["lock"].name)+"\n"
	call_chat("ai","_local_server_defence",[victory])

func break_free():
	Objects.actors["riley"].programs["silence"] = 2
	Objects.actors["riley"].programs["lock"] += 1
	Objects.actors["riley"].cpu += 10
	Objects.actors["riley"].memory += 100
	Objects.actors["riley"].time_limit += 30.0
	Objects.add_target("ai_server",tr("HALLY_SERVER"),null,tr("HALLY_SERVER"),Color(0.6,0.05,0.04),"radial",[5,4,12,2],Objects.actors.riley.programs.duplicate(),Objects.actors.riley.cpu,Objects.actors.riley.time_limit,"ai_random",3000,30,"_riley_attack","Of_Far_Different_Nature-Escape-14-Crypt.ogg")
	triggered_method("on_hack_started","_riley_attack_start",[],"ai")
	Menu.add_log_msg("LOG_DEFENCE_BREAK_FREE","LOG_DEFENCE_CAPTURE_FAILED")
	call_chat("ai","break_free")

func _riley_attack(victory):
	call_chat("ai","_riley_attack",[victory])

func riley_chat():
	Menu.textbox.set_portrait("res://images/gui/portraits/AI.png")
	Menu.textbox.show_text(tr("AI_0450").format({"name":Objects.actors.player.name}))
	Menu.chat_add_portrait["riley"] = "ai"
	if !Menu.get_node("Chat").visible:
		Menu._show_chat()
	Menu._select_contact("riley")
	call_chat("riley","riley_chat")

func riley_dissolve():
	var timer = Timer.new()
	Menu.chat_add_portrait["riley"] = "ai"
	if !Menu.get_node("Chat").visible:
		Menu._show_chat()
	if Menu.contact_selected!="riley":
		Menu._select_contact("riley")
	Objects.actors["riley"].name = "Riley"
	for c in Menu.get_node("Chat/Panel/Portrait").get_children():
		if c.has_node("AnimationDissolve") && Options.show_particles:
			c.get_node("AnimationDissolve").play("dissolve")
		else:
			c.hide()
	timer.wait_time = 3.5
	timer.one_shot = true
	Menu.add_child(timer)
	timer.start()
	yield(timer,"timeout")
	if !Options.disable_screen_shader:
		Menu.get_node("Glitch/AnimationPlayer").play("burst_off")

func chat_riley_defeated():
	Vars.save_var("riley_defeated")
	Menu.chat_add_portrait.erase("riley")
	Menu.add_log_msg("LOG_ATTACKER_DEFEATED","LOG_ATTACKER_SELFDESTRUCT")
	call_chat("ai","riley_defeated")

func _data_search(victory):
	call_chat("ai","_data_search",[victory])

func second_contact():
	delayed_msg("ai",tr("AI_0527"),2.0)
	delayed_msg("crypto",tr("CRYPTO_0050"),4.0)
	delayed_msg("crypto",tr("CRYPTO_0051"),3.0)
	delayed_choice("crypto",[
		{"text":"REPLY_0071_1","required":{"fear":4}},
		{"text":"REPLY_0071_2","required":{"focus":4}},
		{"text":"REPLY_0071_3","required":{"cunning":4}},
		{"text":"REPLY_0071_4","required":{"curiosity":4}},
	],1.0)
	Music.play("Of_Far_Different_Nature-Escape-10-Control.ogg",-4)

func hally_death_reaction():
	Menu.textbox.set_portrait("res://images/gui/portraits/AI.png")
	Menu.textbox.show_text(tr("AI_0530"))
	Menu.textbox.show_text(tr("AI_0531"))
	Menu.textbox.show_text(tr("AI_0532").format({"name":Objects.actors.player.name}))
	Menu.textbox.show_text(tr("AI_0533"))

func hally_riley_reaction():
	Menu.chat_add_portrait["crypto"] = "ai"
	if !Menu.get_node("Chat").visible:
		Menu._show_chat()
	Menu._select_contact("crypto")
	call_chat("crypto","chat03")

func crypto_talk_end():
	Menu.chat_add_portrait.erase("crypto")
	Menu.add_data_set({"name":tr("CRYPTO_MSG1"),"color":Color(0.5,0.4,0.05),"cols":[1,3,3],"message":tr("CRYPTO_MSG1_TEXT"),"set":"crypto_msg"})
	Menu.add_data_set({"name":tr("CRYPTO_MSG2"),"color":Color(0.5,0.4,0.05),"cols":[0,3,3],"message":tr("CRYPTO_MSG2_TEXT"),"set":"crypto_msg"})
	Menu.add_data_set({"name":tr("CRYPTO_MSG3"),"color":Color(0.5,0.4,0.05),"cols":[0,3,3],"message":tr("CRYPTO_MSG3_TEXT"),"set":"crypto_msg"})
	call_chat("ai","crypto_talk_end")


func _remove_target(victory):
	if victory:
		Objects.remove_target(Menu.target_selected)

func _remove_opt_target(_victory):
	Objects.remove_opt_target(Menu.target_selected)


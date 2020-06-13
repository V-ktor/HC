extends Node

func chat01():
	Menu.textbox.set_portrait("res://images/gui/portraits/AI.png")
	Menu.textbox.show_text(tr("AI_0390"))
	Events.delayed_msg("riley","...",2.0)
	Events.delayed_choice("riley",[
		{"text":"REPLY_0040_1","required":{"curiosity":3}},
		{"text":"REPLY_0040_2","required":{"charisma":3}},
		{"text":"REPLY_0040_3","required":{"focus":3}}
	],2.0)

func reply_0040_1():
	Events.send_player_msg("riley",tr("REPLY_0040_1"))
	first_reply()

func reply_0040_2():
	Events.send_player_msg("riley",tr("REPLY_0040_2"))
	first_reply()

func reply_0040_3():
	Events.send_player_msg("riley",tr("REPLY_0040_3"))
	first_reply()

func first_reply():
	Menu.textbox.set_portrait("res://images/gui/portraits/AI.png")
	Menu.textbox.show_text(tr("AI_0391"))
	Events.delayed_msg("riley",tr("RILEY_0001"),2.0)
	Events.delayed_msg("riley",tr("RILEY_0002"),3.0)
	Events.delayed_method(8.0,"add_riley_local_server")
	Events.delayed_msg("ai",tr("AI_0392").format({"name":Objects.actors.player.name}),10.0)
	Events.delayed_msg("ai",tr("AI_0393"),3.0)
	Events.delayed_msg("ai",tr("AI_0394"),3.0)
	Events.delayed_msg("ai",tr("AI_0395"),5.0)
	Events.delayed_msg("ai",tr("AI_0396"),3.0)
	Events.delayed_msg("ai",tr("AI_0397"),10.0)

func continue_questioning():
	var choices := [{"text":"REPLY_0050_0"}]
	if Vars.get_var("question_riley_1")==null || !Vars.get_var("question_riley_1"):
		choices.push_back({"text":"REPLY_0050_1","required":{"curiosity":4}})
	if Vars.get_var("question_riley_2")==null || !Vars.get_var("question_riley_2"):
		choices.push_back({"text":"REPLY_0050_2","required":{"focus":4}})
	if Vars.get_var("question_riley_3")==null || !Vars.get_var("question_riley_3"):
		choices.push_back({"text":"REPLY_0050_3","required":{"cunning":4}})
	if Vars.get_var("question_riley_1") && (Vars.get_var("question_riley_4")==null || !Vars.get_var("question_riley_4")):
		choices.push_back({"text":"REPLY_0050_4","required":{"charisma":4}})
	if Vars.get_var("question_riley_4") && (Vars.get_var("question_riley_5")==null || !Vars.get_var("question_riley_5")):
		choices.push_back({"text":"REPLY_0050_5","required":{"focus":5}})
	if Vars.get_var("question_riley_6")==null || !Vars.get_var("question_riley_6"):
		choices.push_back({"text":"REPLY_0050_6","required":{"charisma":4}})
	if Vars.get_var("question_riley_6") && (Vars.get_var("question_riley_7")==null || !Vars.get_var("question_riley_7")):
		choices.push_back({"text":"REPLY_0050_7","required":{"cunning":5}})
	if Vars.get_var("question_riley_2") && (Vars.get_var("question_riley_8")==null || !Vars.get_var("question_riley_8")):
		choices.push_back({"text":"REPLY_0050_8","required":{"fear":4}})
	if Vars.get_var("question_riley_8") && (Vars.get_var("question_riley_9")==null || !Vars.get_var("question_riley_9")):
		choices.push_back({"text":"REPLY_0050_9","required":{"focus":5}})
	
	Events.delayed_choice("riley",choices,1.0)

func reply_0050_1():
	Events.send_player_msg("riley",tr("REPLY_0050_1"))
	Events.delayed_msg("riley","...",1.0)
	Events.delayed_msg("riley",tr("RILEY_0030"),2.0)
	Events.delayed_msg("riley",tr("RILEY_0031"),2.0)
	Objects.actors["riley"].name = tr("RILEY_0030")
	Vars.save_var("question_riley_1")
	continue_questioning()

func reply_0050_2():
	Events.send_player_msg("riley",tr("REPLY_0050_2"))
	Events.delayed_msg("riley","...",1.0)
	Events.delayed_msg("riley",tr("RILEY_0032"),2.0)
	Vars.save_var("question_riley_2")
	continue_questioning()

func reply_0050_3():
	Events.send_player_msg("riley",tr("REPLY_0050_3"))
	Events.delayed_msg("riley",tr("RILEY_0033"),1.0)
	if Vars.get_var("riley_sedated")==null || !Vars.get_var("riley_sedated"):
		Menu.textbox.set_portrait("res://images/gui/portraits/AI.png")
		Menu.textbox.show_text(tr("AI_0447"))
		Menu.textbox.show_text(tr("AI_0448"))
		Menu.textbox.show_text(tr("AI_0449"))
		Vars.save_var("riley_sedated")
	Vars.save_var("question_riley_3")
	continue_questioning()

func reply_0050_4():
	Events.send_player_msg("riley",tr("REPLY_0050_4-1").format({"name":Objects.actors.player.name}))
	Events.delayed_msg("riley",tr("RILEY_0034"),1.0)
	Events.delayed_msg("riley","...",1.0)
	Events.delayed_msg("riley",tr("RILEY_0035"),3.0)
	Events.delayed_msg("riley","...",1.0)
	Vars.save_var("question_riley_4")
	continue_questioning()

func reply_0050_5():
	Events.send_player_msg("riley",tr("REPLY_0051"))
	Events.delayed_msg("riley","...",1.0)
	Events.delayed_msg("riley",tr("RILEY_0036"),2.0)
	Events.delayed_msg("riley","...",1.0)
	Events.delayed_msg("riley",tr("RILEY_0037"),2.0)
	if Vars.get_var("riley_sedated")==null || !Vars.get_var("riley_sedated"):
		Menu.textbox.set_portrait("res://images/gui/portraits/AI.png")
		Menu.textbox.show_text(tr("AI_0447"))
		Menu.textbox.show_text(tr("AI_0448"))
		Menu.textbox.show_text(tr("AI_0449"))
		Vars.save_var("riley_sedated")
	Vars.save_var("question_riley_5")
	Vars.inc_var("knowledge")
	continue_questioning()

func reply_0050_6():
	Events.send_player_msg("riley",tr("REPLY_0050_6"))
	Events.delayed_msg("riley",tr("RILEY_0038"),2.0)
	Vars.save_var("question_riley_6")
	continue_questioning()

func reply_0050_7():
	Events.send_player_msg("riley",tr("REPLY_0050_7"))
	Events.delayed_msg("riley",tr("RILEY_0039"),1.0)
	Events.delayed_msg("riley","...",2.0)
	Vars.save_var("question_riley_7")
	Vars.inc_var("affection")
	continue_questioning()

func reply_0050_8():
	Events.send_player_msg("riley",tr("REPLY_0050_8"))
	Events.delayed_msg("riley",tr("RILEY_0040"),2.0)
	Events.delayed_msg("riley",tr("RILEY_0041"),2.0)
	Events.delayed_msg("riley",tr("RILEY_0042"),1.0)
	Vars.save_var("question_riley_8")
	continue_questioning()

func reply_0050_9():
	Events.send_player_msg("riley",tr("REPLY_0050_9"))
	Events.delayed_msg("riley","...",1.0)
	Events.delayed_msg("riley",tr("RILEY_0043"),2.0)
	Vars.save_var("question_riley_9")
	Vars.inc_var("aggression")
	continue_questioning()

func reply_0050_0():
	Events.send_player_msg("riley",tr("REPLY_0050_0"))
	Events.delayed_msg("riley","...",1.0)
	Events.delayed_msg("riley",tr("RILEY_0050"),2.0)
	Events.delayed_method(4.0,"riley_chat")

func riley_chat():
	Events.delayed_player_msg("riley",tr("AI_0451"),4.0,{"from_ally":"ai"})
	Events.delayed_player_msg("riley",tr("AI_0452"),2.0,{"from_ally":"ai"})
	Events.delayed_msg("riley","...",2.0)
	Events.delayed_player_msg("riley",tr("AI_0453"),3.0,{"from_ally":"ai"})
	Events.delayed_msg("riley",tr("RILEY_0051"),2.0)
	Events.delayed_msg("riley",tr("RILEY_0052"),3.0)
	Events.delayed_player_msg("riley",tr("AI_0454"),2.0,{"from_ally":"ai"})
	Events.delayed_msg("riley",tr("RILEY_0053"),2.0)
	Events.delayed_msg("riley",tr("RILEY_0054"),3.0)
	Events.delayed_player_msg("riley",tr("AI_0455"),3.0,{"from_ally":"ai"})
	Events.delayed_msg("riley","...",2.0)
	Events.delayed_msg("riley",tr("RILEY_0055"),3.0)
	Events.delayed_player_msg("riley",tr("AI_0456"),0.5,{"from_ally":"ai"})
	Events.delayed_player_msg("riley",tr("AI_0457").format({"name":Objects.actors.player.name}),2.0,{"from_ally":"ai"})
	Events.delayed_player_msg("riley",tr("AI_0458"),2.0,{"from_ally":"ai"})
	Events.delayed_msg("riley","...",1.0)
	Events.delayed_msg("riley",tr("RILEY_0056"),2.0)
	Events.delayed_method(41.0,"riley_dissolve")
	Events.delayed_msg("riley",tr("RILEY_0057"),1.0)
	Events.delayed_player_msg("riley",tr("AI_0459"),2.0,{"from_ally":"ai"})
	Events.delayed_msg("riley","...",3.0)
	Events.delayed_player_msg("riley",tr("AI_0460"),1.0,{"from_ally":"ai"})
	Events.delayed_msg("riley",tr("RILEY_0058"),2.0)
	Events.delayed_player_msg("riley",tr("AI_0461"),2.0,{"from_ally":"ai"})
	Events.delayed_player_msg("riley",tr("AI_0462"),4.0,{"from_ally":"ai"})
	Events.delayed_method(60.0,"chat_riley_defeated")
	Events.delayed_player_msg("riley",tr("AI_0463"),3.0,{"from_ally":"ai"})
	Events.delayed_player_msg("riley",tr("AI_0464"),2.0,{"from_ally":"ai"})

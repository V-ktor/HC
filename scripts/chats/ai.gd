extends Node


func update_bg():
	if Menu.has_node("Chat/Panel/BG") && Menu.get_node("Chat/Panel/BG/Nodes").has_method("add_group") && Menu.get_node("Chat/Panel/BG/Nodes").has_method("remove_group"):
		Menu.get_node("Chat/Panel/BG/Nodes").remove_group()
		Menu.get_node("Chat/Panel/BG/Nodes").add_group()
		for _i in range(2):
			Menu.get_node("Chat/Panel/BG/Nodes").add_node(Menu.get_node("Chat/Panel/BG/Nodes").nodes.size()-1)


func ai_chat01():
	update_bg()
	Music.play("Of_Far_Different_Nature-Escape-02-Deep_Care.ogg",-4.0)
	Events.delayed_msg("ai",tr("AI_0004").replace("<name>",Objects.actors.player.name),0.5)
	Events.delayed_msg("ai",tr("AI_0005"),2.0)
	Events.delayed_choice("ai",[
		{"text":"REPLY_0001_1","personality":{"curiosity":2}},
		{"text":"REPLY_0001_2","personality":{"fear":2}},
		{"text":"REPLY_0001_3","personality":{"charisma":2}}
	],2.0)
	Menu.add_log_msg("LOG_WELCOME","LOG_MET_AI")

func reply_0001_1():
	Events.send_player_msg("ai",tr("REPLY_0001_1"))
	Events.delayed_msg("ai",tr("AI_0006"),1.0)
	Events.delayed_player_msg("ai",tr("REPLY_0002"),2.0)
	Events.delayed_msg("ai",tr("AI_0007"),2.0)
	Objects.actors.ai.data += 16
	ai_chat02()

func reply_0001_2():
	Events.send_player_msg("ai",tr("REPLY_0001_2"))
	Events.delayed_msg("ai",tr("AI_0008"),1.0)
	Events.delayed_msg("ai",tr("AI_0009"),2.0)
	ai_chat02()

func reply_0001_3():
	Events.send_player_msg("ai",tr("REPLY_0001_3"))
	Events.delayed_msg("ai",tr("AI_0010"),1.0)
	Events.delayed_msg("ai",tr("AI_0011"),2.0)
	Events.delayed_player_msg("ai",tr("REPLY_0003"),2.0)
	ai_chat02()

func ai_chat02():
	update_bg()
	Events.delayed_msg("ai",tr("AI_0012"),1.0)
	Events.delayed_msg("ai",tr("AI_0013"),1.0)
	Events.delayed_msg("ai",tr("AI_0014"),2.0)
	Events.delayed_msg("ai",tr("AI_0015"),2.0)
	Events.delayed_msg("ai",tr("AI_0016"),1.0)
	Events.delayed_msg("ai",tr("AI_0017"),2.0)
	Events.delayed_choice("ai",[
		{"text":"REPLY_0004_1","personality":{"curiosity":2}},
		{"text":"REPLY_0004_2","personality":{"cunning":2}},
		{"text":"REPLY_0004_3","personality":{"focus":2}},
		{"text":"REPLY_0004_4","personality":{"fear":2}}
	],2.0)

func reply_0004_1():
	Events.send_player_msg("ai",tr("REPLY_0004_1"))
	Events.delayed_msg("ai",tr("AI_0018"),1.0)
	Events.delayed_player_msg("ai",tr("REPLY_0005"),1.5)
	Events.delayed_msg("ai",tr("AI_0019"),1.5)
	Objects.actors.player.data += 16
	ai_chat03()

func reply_0004_2():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0004_2"))
	Events.delayed_msg("ai",tr("AI_0020"),1.0)
	Events.delayed_msg("ai",tr("AI_0021"),2.0)
	Events.delayed_msg("ai",tr("AI_0022"),2.0)
	Events.delayed_choice("ai",[
		{"text":"REPLY_0006_1","personality":{"focus":1}},
		{"text":"REPLY_0006_2","personality":{"charisma":1}}
	],1.0)

func reply_0006_1():
	Events.send_player_msg("ai",tr("REPLY_0006_1"))
	Events.delayed_msg("ai",tr("AI_0023"),1.0)
	Events.delayed_msg("ai",tr("AI_0024"),1.0)
	ai_chat03()

func reply_0006_2():
	Events.send_player_msg("ai",tr("REPLY_0006_2"))
	Events.delayed_msg("ai",tr("AI_0025"),1.0)
	Events.delayed_msg("ai",tr("AI_0026"),1.0)
	ai_chat03()

func reply_0004_3():
	Events.send_player_msg("ai",tr("REPLY_0004_3"))
	Events.delayed_msg("ai",tr("AI_0027"),1.0)
	Events.delayed_msg("ai",tr("AI_0028"),2.0)
	Events.delayed_player_msg("ai",tr("REPLY_0007"),2.0)
	Events.delayed_msg("ai",tr("AI_0029"),2.0)
	Events.delayed_msg("ai",tr("AI_0030"),2.0)
	ai_chat03()

func reply_0004_4():
	Events.send_player_msg("ai",tr("REPLY_0004_4"))
	Events.delayed_msg("ai",tr("AI_0031"),1.0)
	Events.delayed_msg("ai",tr("AI_0032"),2.0)
	Events.delayed_msg("ai",tr("AI_0033"),1.0)
	Events.delayed_msg("ai",tr("AI_0034"),1.5)
	ai_chat03()

func ai_chat03():
	update_bg()
	Events.delayed_msg("ai",tr("AI_0040"),3.0)
	Events.delayed_msg("ai",tr("AI_0041"),2.0)
	Events.delayed_msg("ai",tr("AI_0042"),3.0)
	Events.delayed_player_msg("ai",tr("REPLY_0010"),2.0)
	Events.delayed_msg("ai",tr("AI_0043"),2.0)
	Events.delayed_msg("ai",tr("AI_0044"),2.0)
	Events.delayed_msg("ai",tr("AI_0045"),4.0)
	Events.delayed_msg("ai",tr("AI_0046"),4.0)
	Events.delayed_msg("ai",tr("AI_0047"),2.0)
	Events.delayed_choice("ai",[
		{"text":"REPLY_0011_1","personality":{"curiosity":1}},
		{"text":"REPLY_0011_2","personality":{"focus":2}},
		{"text":"REPLY_0011_3","personality":{"fear":2}},
		{"text":"REPLY_0011_4","personality":{"cunning":2}}
	],1.0)

func reply_0011_1():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0011_1"))
	Events.delayed_msg("ai",tr("AI_0048"),1.0)
	Events.delayed_msg("ai",tr("AI_0049"),1.5)
	Events.delayed_msg("ai",tr("AI_0050"),1.5)
	Events.delayed_msg("ai",tr("AI_0051"),4.0)
	Events.delayed_msg("ai",tr("AI_0052"),2.0)
	Events.delayed_msg("ai",tr("AI_0053"),2.0)
	Events.delayed_choice("ai",[
		{"text":"REPLY_0011_2","personality":{"focus":2}},
		{"text":"REPLY_0011_3","personality":{"fear":2}},
		{"text":"REPLY_0011_4","personality":{"cunning":2}}
	],1.0)
	Vars.save_var("ai_message_asked")

func reply_0011_2():
	Events.send_player_msg("ai",tr("REPLY_0011_2"))
	ai_chat04()

func reply_0011_3():
	Events.send_player_msg("ai",tr("REPLY_0011_3"))
	Events.delayed_msg("ai",tr("AI_0054"),1.0)
	Events.delayed_msg("ai",tr("AI_0055"),2.0)
	ai_chat04()

func reply_0011_4():
	Events.send_player_msg("ai",tr("REPLY_0011_4"))
	Events.delayed_msg("ai",tr("AI_0056"),1.0)
	Events.delayed_msg("ai",tr("AI_0057"),2.0)
	Events.delayed_msg("ai",tr("AI_0058"),3.0)
	ai_chat04()

func ai_chat04():
	update_bg()
	Events.delayed_msg("ai",tr("AI_0060"),3.0)
	Events.delayed_msg("ai",tr("AI_0061"),3.0)
	Events.delayed_msg("ai",tr("AI_0062"),2.0)
	Events.delayed_msg("ai",tr("AI_0063"),2.0)
	Events.delayed_method(1.0,"show_web")
	Objects.add_target("local_server",(tr("YOUR_SERVER")%Objects.actors["player"].name).capitalize(),null,"127.0.0.1",Color(0.4,0.3,0.2),"layered",[5,3,14],{"pulse":4,"fire_wall":2,"anti_virus":4},8,"ai_random",500,10,"_local_server_hack")
	Events.delayed_msg("ai",tr("AI_0064"),2.0)
	Events.delayed_choice("ai",[
		{"text":"REPLY_0012_1"},
		{"text":"REPLY_0012_2"}
	],1.0)

func reply_0012_1():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0012_1"))
	Events.delayed_msg("ai",tr("AI_0065"),1.0)
	Events.delayed_msg("ai",tr("AI_0066"),2.0)
	Vars.save_var("show_hack_tutorial")
	Events.triggered_method("on_hack_started","_intro_hack_tutorial",[],"ai")

func reply_0012_2():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0012_2"))
	Events.delayed_msg("ai",tr("AI_0067"),1.0)

func _intro_hack_tutorial(_target):
	Menu.textbox.set_portrait("res://images/gui/portraits/AI.png")
	Menu.textbox.show_text(tr("AI_0260"))
	Menu.textbox.show_text(tr("AI_0261"))
	Menu.textbox.show_text(tr("AI_0262"))
	Menu.textbox.show_text(tr("AI_0263")%OS.get_scancode_string(InputMap.get_action_list("action1")[0].scancode))
	Menu.textbox.show_text(tr("AI_0264"))
	Menu.textbox.show_text(tr("AI_0265"))
	Menu.textbox.show_text(tr("AI_0266"))

func _local_server_hack(victory):
	if victory:
		Menu.add_hack_msg(tr("AI_0071"))
		Events.delayed_hack_msg(tr("AI_0072"),2.0)
		Objects.remove_target("local_server")
		Events.delayed_msg("ai",tr("AI_0073"),6.0)
		Events.delayed_msg("ai",tr("AI_0074"),2.0)
		Events.delayed_msg("ai",tr("AI_0075"),4.0)
		Events.delayed_msg("ai",tr("AI_0076"),3.0)
		if !Vars.get_var("ai_message_asked"):
			Events.delayed_msg("ai",tr("AI_0077"),6.0)
			Events.delayed_msg("ai",tr("AI_0049"),3.0)
			Events.delayed_msg("ai",tr("AI_0050"),2.0)
			Events.delayed_msg("ai",tr("AI_0053"),2.0)
		Events.delayed_msg("ai",tr("AI_0078"),6.0)
		Events.delayed_method(0.5,"show_compile")
		Events.delayed_msg("ai",tr("AI_0079"),1.0)
		Menu.add_tech("fire_wall")
		Events.triggered_method("on_show_compile","compile_intro",[],"ai")
		Events.triggered_method("on_gained_tech","gained_first_tech",[],"ai")
		Events.triggered_method("on_hack_success","intro_hack_success",[],"ai")
		Menu.add_log_msg("LOG_HACKED_LOCAL_HOST","LOG_HACKED_LOCAL_HOST")
		Objects.actors.player.data += 32
	else:
		Menu.add_hack_msg(tr("AI_0070"))

func compile_intro():
	Menu.textbox.set_portrait("res://images/gui/portraits/AI.png")
	Menu.textbox.show_text(tr("AI_0080"))
	Menu.textbox.show_text(tr("AI_0081"),false)
	Menu.textbox.show_text(tr("AI_0082"))
	Menu.textbox.show_text(tr("AI_0083"))
	Events.delayed_method(5.0,"allow_scan")

func intro_hack_success(_target):
	Events.delayed_hack_msg(tr("AI_0084"),1.0)
	Events.delayed_hack_msg(tr("AI_0085"),2.0)
	Events.delayed_hack_msg(tr("AI_0086"),3.0)
	Events.delayed_method(4.0,"show_upgrades")
	Events.triggered_method("on_show_upgrades","upgrade_intro",[],"ai")
	Events.triggered_method("on_create_hack_files","first_hack_file",[],"ai")
	Menu.add_log_msg("LOG_HARD_WORK","LOG_CONTINUE")

func upgrade_intro():
	Menu.textbox.set_portrait("res://images/gui/portraits/AI.png")
	Menu.textbox.show_text(tr("AI_0087"))
	Menu.textbox.show_text(tr("AI_0088"))

func gained_first_tech(tech):
	Events.delayed_hack_msg(tr("AI_0090"),1.0)
	Events.delayed_hack_msg(tr("AI_0091"),2.0)
	if tech=="fire_wall" || tech=="anti_virus":
		Events.delayed_hack_msg(tr("AI_0092"),3.0)
		Events.delayed_hack_msg(tr("AI_0093"),3.0)
	elif tech=="wave" || tech=="beam_cannon":
		Events.delayed_hack_msg(tr("AI_0094"),2.0)
	Events.delayed_hack_msg(tr("AI_0095"),4.0)
	Events.triggered_method("on_decompile","decompiled_first_tech",[],"ai")

func first_hack_file(_target,files):
	if randf()<0.25:
		Events.triggered_method("on_create_hack_files","first_hack_file",[],"ai")
		return
	
	var index = Vars.get_var("first_hack_files")
	if index==null:
		index = 0
	files.push_back({"name":Objects.actors.player.name+"_"+tr("WAS_HERE")+".txt","size":int(rand_range(16.0,64.0))})
	Events.delayed_hack_msg(tr("AI_0201"),1.0)
	Events.delayed_hack_msg(tr("AI_020"+str(2+randi()%6)),2.0)
	if index==0:
		Events.delayed_hack_msg(tr("AI_0209"),2.0)
		Events.delayed_hack_msg(tr("AI_0210"),3.0)
	elif index==1:
		Events.delayed_hack_msg(tr("AI_0211"),2.0)
		Events.delayed_hack_msg(tr("AI_0212"),3.0)
	elif index==2:
		Events.delayed_hack_msg(tr("AI_0213"),3.0)
		Events.delayed_hack_msg(tr("AI_0214"),4.0)
		Events.delayed_hack_msg(tr("AI_0215").replace("<name>",Objects.actors.player.name),2.0)
	elif index==3:
		Events.delayed_hack_msg(tr("AI_0216"),3.0)
		Events.delayed_hack_msg(tr("AI_0217"),2.0)
		Events.delayed_hack_msg(tr("AI_0218"),3.0)
	elif index==4:
		Events.delayed_hack_msg(tr("AI_0219"),2.0)
		Events.delayed_hack_msg(tr("AI_0220"),3.0)
		Events.delayed_hack_msg(tr("AI_0221"),2.0)
		Events.delayed_hack_msg(tr("AI_0222"),3.0)
		Events.delayed_hack_msg(tr("AI_0223"),4.0)
	elif index==5:
		Events.delayed_hack_msg(tr("AI_0224"),3.0)
		Events.delayed_hack_msg(tr("AI_0225"),3.0)
	
	Vars.inc_var("first_hack_files")
	if Vars.get_var("first_hack_files")<6:
		Events.triggered_method("on_create_hack_files","first_hack_file",[],"ai")
	else:
		Events.delayed_msg("ai",tr("AI_0231"),8.0)
		Events.delayed_msg("ai",tr("AI_0232"),3.0)
		Events.delayed_msg("ai",tr("AI_0233"),2.0)
		Events.delayed_msg("ai",tr("AI_0234"),6.0)
		Events.delayed_choice("ai",[
			{"text":"REPLY_0013_1","required":{"focus":2},"personality":{"focus":1}},
			{"text":"REPLY_0013_2","required":{"fear":2},"personality":{"fear":1}},
			{"text":"REPLY_0013_3","required":{"charisma":2},"personality":{"charisma":1}}
		],1.0)

func reply_0013_1():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0013_1"))
	Events.delayed_msg("ai",tr("AI_0235"),1.0)
	Events.delayed_msg("ai",tr("AI_0236"),2.0)
	Events.delayed_choice("ai",[
		{"text":"REPLY_0014_1","personality":{"charisma":1}},
		{"text":"REPLY_0014_2","personality":{"fear":1}}
	],1.0)

func reply_0014_1():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0014_1"))
	Events.delayed_msg("ai",tr("AI_0237"),1.0)
	Events.delayed_msg("ai",tr("AI_0238"),2.0)
	end_part1_conversation()

func reply_0014_2():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0014_1"))
	Events.delayed_msg("ai",tr("AI_0239"),1.0)
	Events.delayed_msg("ai",tr("AI_0240"),3.0)
	end_part1_conversation()

func reply_0013_2():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0013_2"))
	Events.delayed_player_msg("ai",tr("REPLY_0013_2-2"),2.0)
	Events.delayed_msg("ai",tr("AI_0241"),1.0)
	Events.delayed_msg("ai",tr("AI_0242"),2.0)
	Events.delayed_msg("ai",tr("AI_0243"),1.0)
	Events.delayed_msg("ai",tr("AI_0244"),4.0)
	Events.delayed_choice("ai",[
		{"text":"REPLY_0015_1","personality":{"cunning":1}},
		{"text":"REPLY_0015_2","personality":{"focus":1}}
	],1.0)

func reply_0015_1():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0015_1"))
	Events.delayed_msg("ai",tr("AI_0245"),1.0)
	Events.delayed_msg("ai",tr("AI_0246"),2.0)
	end_part1_conversation()

func reply_0015_2():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0015_2"))
	Events.delayed_msg("ai",tr("AI_0247"),2.0)
	end_part1_conversation()

func reply_0013_3():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0013_3"))
	Events.delayed_msg("ai",tr("AI_0237"),1.0)
	Events.delayed_msg("ai",tr("AI_0238"),2.0)
	Events.delayed_choice("ai",[
		{"text":"REPLY_0016_1","personality":{"cunning":1}},
		{"text":"REPLY_0016_2","personality":{"fear":1}}
	],1.0)

func reply_0016_1():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0016_1"))
	Events.delayed_msg("ai",tr("AI_0248"),1.0)
	Events.delayed_msg("ai",tr("AI_0249"),2.0)
	end_part1_conversation()

func reply_0016_2():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0016_2"))
	Events.delayed_msg("ai",tr("AI_0250"),2.0)
	end_part1_conversation()

func end_part1_conversation():
	Events.delayed_msg("ai",tr("AI_END_01"),2.0)
	Events.delayed_msg("ai",tr("AI_END_02"),3.0)
	Events.delayed_msg("ai",tr("AI_END_03"),1.0)
	Events.delayed_msg("ai",tr("AI_END_04"),3.0)
	Events.delayed_msg("ai",tr("AI_END_05"),1.0)
	Vars.save_var("part1_finished")


func decompiled_first_tech(prgm):
	Events.delayed_msg("ai",tr("AI_0096"),2.0)
	Events.delayed_msg("ai",tr("AI_0097").replace("<name>",tr(prgm.to_upper())),2.0)
	Events.delayed_msg("ai",tr("AI_0098"),8.0)
	Events.delayed_msg("ai",tr("AI_0099"),4.0)
	Events.delayed_method(6.0,"show_code")
	Events.triggered_method("on_show_code","code_intro",[],"ai")

func code_intro():
	Menu.textbox.set_portrait("res://images/gui/portraits/AI.png")
	Menu.textbox.show_text(tr("AI_0280"))
	Menu.textbox.show_text(tr("AI_0281"))
	Menu.textbox.show_text(tr("AI_0282"))


func suggest_contact():
	Events.delayed_msg("ai",tr("AI_0300"),2.0)
	Events.delayed_msg("ai",tr("AI_0301"),2.0)
	Events.delayed_msg("ai",tr("AI_0302"),6.0)
	Events.delayed_choice("ai",[
		{"text":"REPLY_0020_1","personality":{"focus":2}},
		{"text":"REPLY_0020_2","personality":{"fear":2}},
		{"text":"REPLY_0020_3","personality":{"cunning":2}}
	],2.0)

func reply_0020_1():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0020_1"))
	Events.delayed_msg("ai",tr("AI_0303"),1.0)
	Events.delayed_msg("ai",tr("AI_0304"),3.0)
	Events.delayed_msg("ai",tr("AI_0305"),2.0)
	Events.delayed_choice("ai",[
		{"text":"REPLY_0021_1","personality":{"focus":1}},
		{"text":"REPLY_0021_2","personality":{"cunning":1}}
	],2.0)

func reply_0021_1():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0021_1"))
	Events.delayed_msg("ai",tr("AI_0306"),1.0)
	init_call()

func reply_0021_2():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0021_2"))
	Events.delayed_player_msg("ai",tr("REPLY_0021_3"),2.0)
	Events.delayed_msg("ai",tr("AI_0307"),1.0)
	init_call()

func reply_0020_2():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0020_2"))
	Events.delayed_msg("ai",tr("AI_0310"),1.0)
	Events.delayed_msg("ai",tr("AI_0311"),3.0)
	Events.delayed_msg("ai",tr("AI_0312"),2.0)
	Events.delayed_msg("ai",tr("AI_0313"),3.0)
	Events.delayed_choice("ai",[
		{"text":"REPLY_0022_1","personality":{"fear":1}},
		{"text":"REPLY_0022_2","personality":{"charisma":1}}
	],2.0)

func reply_0022_1():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0022_1"))
	Events.delayed_msg("ai",tr("AI_0314"),1.0)
	Events.delayed_msg("ai",tr("AI_0306"),2.0)
	init_call()

func reply_0022_2():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0022_2"))
	Events.delayed_msg("ai",tr("AI_0315"),1.0)
	Events.delayed_msg("ai",tr("AI_0306"),2.0)
	init_call()

func reply_0020_3():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0020_3"))
	Events.delayed_msg("ai",tr("AI_03"),1.0)
	Events.delayed_msg("ai",tr("AI_03"),2.0)
	Events.delayed_msg("ai",tr("AI_03"),3.0)
	Events.delayed_msg("ai",tr("AI_03"),3.0)
	Events.delayed_choice("ai",[
		{"text":"REPLY_0023_1","personality":{"cunning":1}},
		{"text":"REPLY_0023_2","personality":{"charisma":1}}
	],2.0)

func reply_0023_1():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0023_1"))
	Events.delayed_msg("ai",tr("AI_0330"),1.0)
	Events.delayed_msg("ai",tr("AI_0331"),2.0)
	Events.delayed_msg("ai",tr("AI_0332"),3.0)
	Events.delayed_player_msg("ai",tr("REPLY_0021_1"),2.0)
	init_call()

func reply_0023_2():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0023_2"))
	Events.delayed_msg("ai",tr("AI_0333"),1.0)
	Events.delayed_msg("ai",tr("AI_0332"),3.0)
	Events.delayed_player_msg("ai",tr("REPLY_0021_1"),2.0)
	init_call()

func init_call():
	Events.delayed_msg("ai",tr("AI_0340"),4.0)
	Events.delayed_method(4.0,"add_npc1")

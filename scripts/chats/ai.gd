extends Node

var box


func update_bg():
	if Menu.has_node("Chat/Panel/BG") && Menu.get_node("Chat/Panel/BG/Nodes").has_method("add_group") && Menu.get_node("Chat/Panel/BG/Nodes").has_method("remove_group"):
		Menu.get_node("Chat/Panel/BG/Nodes").remove_group()
		Menu.get_node("Chat/Panel/BG/Nodes").add_group()
		for _i in range(2):
			Menu.get_node("Chat/Panel/BG/Nodes").add_node(Menu.get_node("Chat/Panel/BG/Nodes").nodes.size()-1)


func ai_chat01():
	update_bg()
	Music.play("Of_Far_Different_Nature-Escape-02-Deep_Care.ogg",-4.0)
	Events.delayed_msg("ai",tr("AI_0004").format({"name":Objects.actors.player.name}),0.5)
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
	Events.delayed_method(0.5,"show_web")
	Objects.add_target("local_server",(tr("YOUR_SERVER")%Objects.actors["player"].name).capitalize(),null,"127.0.0.1",Color(0.4,0.3,0.2),"layered",[5,3,10],{"pulse":4,"fire_wall":2,"anti_virus":4},8,"ai_random",500,10,"_local_server_hack")
	Events.delayed_msg("ai",tr("AI_0064"),0.5)
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
	var index = Vars.get_var("first_hack_files")
	if index==null:
		index = 0
	files.push_back({"name":Objects.actors.player.name+"_"+tr("WAS_HERE")+".txt","size":int(rand_range(16.0,64.0))})
	Events.delayed_hack_msg(tr("AI_0201"),1.0)
	Events.delayed_hack_msg(tr("AI_020"+str(2+randi()%6)).replace("{name}",Objects.actors.player.name),2.0)
	if index==0:
		Events.delayed_hack_msg(tr("AI_0209"),2.0)
		Events.delayed_hack_msg(tr("AI_0210"),3.0)
	elif index==1:
		Events.delayed_hack_msg(tr("AI_0211"),2.0)
		Events.delayed_hack_msg(tr("AI_0212"),3.0)
	elif index==2:
		Events.delayed_hack_msg(tr("AI_0213"),3.0)
		Events.delayed_hack_msg(tr("AI_0214"),4.0)
		Events.delayed_hack_msg(tr("AI_0215").format({"name":Objects.actors.player.name}),2.0)
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
			{"text":"REPLY_0013_1","personality":{"focus":1}},
			{"text":"REPLY_0013_2","personality":{"fear":1}},
			{"text":"REPLY_0013_3","personality":{"charisma":1}}
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
	suggest_contact()

func reply_0014_2():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0014_1"))
	Events.delayed_msg("ai",tr("AI_0239"),1.0)
	Events.delayed_msg("ai",tr("AI_0240"),3.0)
	suggest_contact()

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
	suggest_contact()

func reply_0015_2():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0015_2"))
	Events.delayed_msg("ai",tr("AI_0247"),2.0)
	suggest_contact()

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
	suggest_contact()

func reply_0016_2():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0016_2"))
	Events.delayed_msg("ai",tr("AI_0250"),2.0)
	suggest_contact()

func decompiled_first_tech(prgm):
	Events.delayed_msg("ai",tr("AI_0096"),2.0)
	Events.delayed_msg("ai",tr("AI_0097").format({"name":tr(prgm.to_upper())}),2.0)
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
	Events.delayed_msg("ai",tr("AI_0300"),20.0)
	Events.delayed_msg("ai",tr("AI_0301"),2.0)
	Events.delayed_msg("ai",tr("AI_0302"),4.0)
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
	Events.delayed_msg("ai",tr("AI_0320"),1.0)
	Events.delayed_msg("ai",tr("AI_0321"),2.0)
	Events.delayed_msg("ai",tr("AI_0322"),3.0)
	Events.delayed_msg("ai",tr("AI_0323"),3.0)
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

func failed_call():
	Events.delayed_msg("ai",tr("AI_0370"),4.0)
	Events.delayed_msg("ai",tr("AI_0371"),3.0)
	Events.delayed_msg("ai",tr("AI_0372"),3.0)
	Events.delayed_method(60.0,"under_attack")

func under_attack():
	Music.play("Of_Far_Different_Nature-Escape-05-Silence.ogg")
	Menu.textbox.set_portrait("res://images/gui/portraits/AI.png")
	Menu.textbox.show_text(tr("AI_0380"))
	Menu.textbox.show_text(tr("AI_0381"))
	Menu.textbox.show_text(tr("AI_0382").format({"name":Objects.actors.player.name}))
	Events.delayed_msg("ai",tr("AI_0382").format({"name":Objects.actors.player.name}),6.0)
	Events.delayed_msg("ai",tr("AI_0383"),3.0)
	Events.delayed_msg("ai",tr("AI_0384"),4.0)
	Events.delayed_msg("ai",tr("AI_0385"),8.0)
	Events.delayed_msg("ai",tr("AI_0386"),4.0)
	Events.delayed_msg("ai",tr("AI_0387"),4.0)
	Events.delayed_msg("ai",tr("AI_0388"),6.0)
	Events.delayed_msg("ai",tr("AI_0389"),4.0)
	Events.delayed_method(1.0,"add_riley")

func _riley_defence_start(target):
	if Objects.targets[target].method_on_win=="_local_server_defence":
		Menu.textbox.set_portrait("res://images/gui/portraits/AI.png")
		Menu.textbox.show_text(tr("AI_0398"))
		Menu.textbox.show_text(tr("AI_0399"))
		Menu.textbox.show_text(tr("AI_0400"))
		get_node("/root/Main").victory_on_root_capture = true
	Events.triggered_method("on_hack_started","_riley_defence_start",[],"ai")

func _local_server_defence(victory):
	if victory:
		Music.play("Of_Far_Different_Nature-Escape-02-Deep_Care.ogg",-4.0)
		Menu.hack_contact_overwrite = ""
		Menu.add_hack_msg(tr("AI_0401"))
		Events.delayed_hack_msg(tr("AI_0402"),3.0)
		Events.delayed_msg("ai",tr("AI_0403"),4.0)
		Events.delayed_msg("ai",tr("AI_0404"),3.0)
		Events.delayed_msg("ai",tr("AI_0405"),2.0)
		Events.delayed_msg("ai",tr("AI_0406"),4.0)
		Events.delayed_msg("ai",tr("AI_0407"),2.0)
		Events.delayed_msg("ai",tr("AI_0408"),4.0)
		Events.delayed_choice("ai",[
			{"text":"REPLY_0041_1","personality":{"charisma":1}},
			{"text":"REPLY_0041_2","personality":{"curiosity":1}},
			{"text":"REPLY_0041_3","personality":{"focus":1}},
			{"text":"REPLY_0041_4","personality":{"fear":1}}
		],2.0)
		Objects.remove_target("local_server")
		Menu.add_log_msg("LOG_DEFENCE_SUCCESS","LOG_DEFENCE_CAPTURE")
		Objects.actors.player.data += 32
		box = load("res://scenes/misc/giftbox.tscn").instance()
		box.position = OS.window_size/2
		Menu.add_child(box)
		for i in range(Events.triggered.size()):
			if Events.triggered[i].method=="_riley_defence_start":
				Events.triggered.remove(i)
	else:
		Menu.hack_contact_overwrite = "riley"
		Menu.add_hack_msg(tr("RILEY_001"+str(randi()%4)))

func reply_0041_1():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0041_1"))
	Events.delayed_msg("ai",tr("AI_0410"),2.0)
	Events.delayed_msg("ai",tr("AI_0411"),3.0)
	Events.delayed_msg("ai",tr("AI_0412"),3.0)
	Events.delayed_method(2.0,"break_free")
	Vars.inc_var("affection")

func reply_0041_2():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0041_2"))
	Events.delayed_method(2.0,"break_free")
	Vars.inc_var("affection")

func reply_0041_3():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0041_3"))
	Events.delayed_msg("ai",tr("AI_0414"),2.0)
	Events.delayed_msg("ai",tr("AI_0415"),3.0)
	Events.delayed_method(2.0,"break_free")
	Vars.inc_var("aggression")

func reply_0041_4():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0041_4"))
	Events.delayed_msg("ai",tr("AI_0416"),3.0)
	Events.delayed_method(2.0,"break_free")
	Vars.inc_var("aggression")

func break_free():
	var timer := Timer.new()
	if box==null:
		box = load("res://scenes/misc/giftbox.tscn").instance()
		box.position = OS.window_size/2
		Menu.add_child(box)
	Music.play("Of_Far_Different_Nature-Escape-05-Silence.ogg")
	Events.send_msg("ai",tr("AI_0413"))
	Events.delayed_msg("ai",tr("AI_0420"),2.0)
	Events.delayed_msg("ai",tr("AI_0421").format({"name":Objects.actors.player.name}),4.0)
	Events.delayed_msg("ai",tr("AI_0422"),3.0)
	Events.delayed_msg("ai",tr("AI_0423"),2.0)
	Events.delayed_msg("ai",tr("AI_0424").format({"name":Objects.actors.player.name}),3.0)
	Events.delayed_msg("ai",tr("AI_0425"),10.0)
	Events.delayed_msg("ai",tr("AI_0426"),10.0)
	Events.delayed_msg("ai",tr("AI_0427"),10.0)
	box.get_node("AnimationPlayer").play("explode")
	timer.wait_time = 2.0
	timer.one_shot = true
	Menu.add_child(timer)
	timer.start()
	yield(timer,"timeout")
	if !Options.disable_screen_shader:
		Menu.get_node("Glitch/AnimationPlayer").play("burst_off")

func _riley_attack_start(target):
	if Objects.targets[target].method_on_win=="_riley_attack":
		Menu.hack_contact_overwrite = "riley"
		Menu.update_hack_chat()
		Menu.get_node("Hack/Panel").show()
		Menu.textbox.set_portrait("res://images/gui/portraits/AI.png")
		Menu.textbox.show_text(tr("AI_0430"))
		Menu.textbox.show_text(tr("AI_0431"))
		Menu.textbox.show_text(tr("AI_0432"))
		Menu.textbox.connect("closed",Menu.get_node("Hack/Panel"),"hide",[],CONNECT_ONESHOT)
	Events.triggered_method("on_hack_started","_riley_attack_start",[],"ai")
	if Objects.targets[target].method_on_win=="_riley_attack":
		var timer = Timer.new()
		timer.wait_time = 2.0
		timer.one_shot = true
		Menu.add_child(timer)
		timer.connect("timeout",Menu,"add_hack_msg",[tr("RILEY_0021")])
		timer.connect("timeout",timer,"queue_free")
		timer.start()
		yield(get_tree(),"idle_frame")
		Menu.hack_contact_overwrite = "riley"
		Menu.add_hack_msg(tr("RILEY_0020"))
		Menu.update_hack_chat()

func _riley_attack(victory):
	if victory:
		Music.play("Of_Far_Different_Nature-Escape-05-Silence.ogg")
		Menu.hack_contact_overwrite = ""
		Menu.chat_hack_log.clear()
		Events.delayed_hack_msg(tr("AI_0440"),1.0)
		Events.delayed_hack_msg(tr("AI_0441"),2.0)
		Events.delayed_hack_msg(tr("AI_0442"),1.0)
		Events.delayed_hack_msg(tr("AI_0443"),3.0)
		Events.delayed_hack_msg(tr("AI_0444"),2.0)
		Events.delayed_hack_msg(tr("AI_0445"),2.0)
		Events.delayed_msg("riley","...",1.0)
		Events.delayed_choice("riley",[
			{"text":"REPLY_0050_1","required":{"curiosity":4}},
			{"text":"REPLY_0050_2","required":{"focus":4}},
			{"text":"REPLY_0050_3","required":{"cunning":4}}
		],1.0)
		Events.delayed_hack_msg(tr("AI_0446"),1.0)
		Objects.remove_target("ai_server")
		Objects.actors["riley"].portrait = "res://scenes/portraits/riley.tscn"
		Menu.add_log_msg("LOG_DEFENCE_SUCCESS","LOG_DEFENCE_RECAPTURE")
		Objects.actors.player.data += 48
		for i in range(Events.triggered.size()):
			if Events.triggered[i].method=="_riley_attack_start":
				Events.triggered.remove(i)
	else:
		Menu.hack_contact_overwrite = "riley"
		Menu.add_hack_msg(tr("RILEY_001"+str(randi()%4)))

func riley_defeated():
	Events.add_choice("ai",[
		{"text":"REPLY_0060_1","personality":{"focus":1}},
		{"text":"REPLY_0060_2","personality":{"charisma":1}},
		{"text":"REPLY_0060_3","personality":{"curiosity":1}}
	])

func reply_0060_1():
	update_bg()
	Music.play("Of_Far_Different_Nature-Escape-02-Deep_Care.ogg",-4.0)
	Events.send_player_msg("ai",tr("REPLY_0060_1"))
	ask_about_riley()

func reply_0060_2():
	update_bg()
	Music.play("Of_Far_Different_Nature-Escape-02-Deep_Care.ogg",-4.0)
	Events.send_player_msg("ai",tr("REPLY_0060_2"))
	Events.delayed_msg("ai",tr("AI_0470"),1.0)
	Events.delayed_msg("ai",tr("AI_0471"),2.0)
	ask_about_riley()

func reply_0060_3():
	update_bg()
	Music.play("Of_Far_Different_Nature-Escape-02-Deep_Care.ogg",-4.0)
	Events.send_player_msg("ai",tr("REPLY_0060_3"))
	ask_about_riley()

func ask_about_riley():
	Events.delayed_msg("ai",tr("AI_0472"),2.0)
	Events.delayed_msg("ai",tr("AI_0473"),3.0)
	Events.delayed_msg("ai",tr("AI_0474"),3.0)
	Events.delayed_choice("ai",[
		{"text":"REPLY_0061_1","personality":{"focus":1}},
		{"text":"REPLY_0061_2","personality":{"charisma":1}},
		{"text":"REPLY_0061_3","personality":{"fear":1}},
		{"text":"REPLY_0061_4","personality":{"cunning":1}}
	],2.0)

func reply_0061_1():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0061_1"))
	Events.delayed_msg("ai",tr("AI_0475"),1.0)
	ai_chat05()

func reply_0061_2():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0061_2"))
	Events.delayed_msg("ai",tr("AI_0476"),1.0)
	ai_chat05()

func reply_0061_3():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0061_3"))
	Events.delayed_msg("ai",tr("AI_0477"),1.0)
	Events.delayed_msg("ai",tr("AI_0478"),3.0)
	ai_chat05()

func reply_0061_4():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0061_4"))
	Events.delayed_msg("ai",tr("AI_0479"),1.0)
	Events.delayed_msg("ai",tr("AI_0480"),2.0)
	ai_chat05()

func ai_chat05():
	Events.delayed_msg("ai",tr("AI_0481"),2.0)
	Events.delayed_msg("ai",tr("AI_0482"),2.0)
	Events.delayed_msg("ai",tr("AI_0483"),3.0)
	Events.delayed_msg("ai",tr("AI_0484"),2.0)
	Events.delayed_msg("ai",tr("AI_0485"),4.0)
	Events.delayed_msg("ai",tr("AI_0486"),3.0)
	Events.delayed_msg("ai",tr("AI_0487"),4.0)
	Events.delayed_msg("ai",tr("AI_0488"),3.0)
	Events.delayed_choice("ai",[
		{"text":"REPLY_0062_1","personality":{"curiosity":1}},
		{"text":"REPLY_0062_2","personality":{"charisma":1}},
		{"text":"REPLY_0062_3","personality":{"focus":1}},
		{"text":"REPLY_0062_4","personality":{"cunning":1}}
	],2.0)

func reply_0062_1():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0062_1"))
	Events.delayed_msg("ai",tr("AI_0489"),1.0)
	Events.delayed_msg("ai",tr("AI_0490"),2.0)
	Events.delayed_msg("ai",tr("AI_0496"),3.0)
	ai_chat06()

func reply_0062_2():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0062_2"))
	Events.delayed_msg("ai",tr("AI_0491"),1.0)
	Events.delayed_msg("ai",tr("AI_0492"),2.0)
	Events.delayed_msg("ai",tr("AI_0496"),3.0)
	ai_chat06()

func reply_0062_3():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0062_3"))
	Events.delayed_msg("ai",tr("AI_0493"),2.0)
	Events.delayed_msg("ai",tr("AI_0496"),3.0)
	ai_chat06()

func reply_0062_4():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0062_4"))
	Events.delayed_msg("ai",tr("AI_0494"),1.0)
	Events.delayed_msg("ai",tr("AI_0495"),2.0)
	ai_chat06()

func ai_chat06():
	Events.delayed_msg("ai",tr("AI_0497"),3.0)
	Events.delayed_msg("ai",tr("AI_0498"),3.0)
	Events.delayed_choice("ai",[
		{"text":"REPLY_0063_1","personality":{"curiosity":1}},
		{"text":"REPLY_0063_2","personality":{"focus":1}},
		{"text":"REPLY_0063_3","personality":{"cunning":1}}
	],2.0)

func reply_0063_1():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0063_1"))
	Events.delayed_msg("ai",tr("AI_0499"),1.0)
	Events.delayed_msg("ai",tr("AI_0500"),2.0)
	init_scan_data()

func reply_0063_2():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0063_2"))
	Events.delayed_msg("ai",tr("AI_0499"),1.0)
	Events.delayed_msg("ai",tr("AI_0500"),2.0)
	init_scan_data()

func reply_0063_3():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0063_3"))
	Events.delayed_msg("ai",tr("AI_0501"),1.0)
	Events.delayed_msg("ai",tr("AI_0502"),3.0)
	Events.delayed_msg("ai",tr("AI_0503"),2.0)
	init_scan_data()

func init_scan_data():
	Events.delayed_msg("ai",tr("AI_0504"),2.0)
	Events.delayed_msg("ai",tr("AI_0505"),3.0)
	Events.delayed_msg("ai",tr("AI_0506"),4.0)
	Events.delayed_msg("ai",tr("AI_0507"),3.0)
	Events.delayed_msg("ai",tr("AI_0508"),2.0)
	Events.delayed_msg("ai",tr("AI_0509"),2.0)
	Events.delayed_msg("ai",tr("AI_0510"),1.0)
	Objects.add_target("data_server",tr("DATA_STORAGE"),null,tr("DATA_STORAGE"),Color(0.6,0.05,0.04),"radial",[4,4,12,2],{"pulse":4,"wave":2,"phalanx":2,"scythe":4,"parry":4,"lock":2},20,"ai_random",2000,20,"_data_search")

func _data_search(victory):
	if victory:
		Vars.inc_var("data_search")
		Menu.add_hack_msg(tr("AI_051"+str(2+randi()%6)))
		if Vars.get_var("data_search")>5:
			data_found()
	else:
		Menu.add_hack_msg(tr("AI_0511"))

func data_found():
	Objects.remove_target("data_server")
	Events.delayed_msg("ai",tr("AI_0520"),4.0)
	Events.delayed_msg("ai",tr("AI_0521"),2.0)
	Events.delayed_msg("ai",tr("AI_0522"),4.0)
	Events.delayed_msg("ai",tr("AI_0523"),3.0)
	Events.delayed_msg("ai",tr("AI_0524"),2.0)
	Events.delayed_msg("ai",tr("AI_0525"),2.0)
	Events.delayed_msg("ai",tr("AI_0526"),2.0)
	Events.delayed_choice("ai",[
		{"text":"REPLY_0070_1","personality":{"focus":1}},
		{"text":"REPLY_0070_2","personality":{"charisma":1}},
		{"text":"REPLY_0070_3","personality":{"cunning":1}}
	],1.0)

func reply_0070_1():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0070_1"))
	Events.second_contact()

func reply_0070_2():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0070_2"))
	Events.second_contact()

func reply_0070_3():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0070_3"))
	Events.second_contact()

func crypto_talk_end():
	Events.delayed_msg("ai",tr("AI_0560"),1.0)
	Events.delayed_msg("ai",tr("AI_0561"),3.0)
	Events.delayed_msg("ai",tr("AI_0562"),2.0)
	Events.delayed_msg("ai",tr("AI_0563"),2.0)
	Events.delayed_msg("ai",tr("AI_0564"),4.0)
	Events.delayed_msg("ai",tr("AI_0565"),2.0)
	Events.delayed_msg("ai",tr("AI_0566"),3.0)
	Events.delayed_msg("ai",tr("AI_0567"),2.0)
	Events.delayed_choice("ai",[
		{"text":"REPLY_0080_1","personality":{"charisma":1}},
		{"text":"REPLY_0080_2","personality":{"curiosity":1}},
		{"text":"REPLY_0080_3","personality":{"fear":1}}
	],1.0)

func reply_0080_1():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0080_1"))
	Events.delayed_msg("ai",tr("AI_0570"),1.0)
	Events.delayed_msg("ai",tr("AI_0571"),1.0)
	Events.delayed_choice("ai",[
		{"text":"REPLY_0081_1","personality":{"charisma":1}},
		{"text":"REPLY_0081_2","personality":{"curiosity":1}},
		{"text":"REPLY_0081_5","personality":{"cunning":1}}
	],1.0)

func reply_0080_2():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0080_2"))
	Events.delayed_msg("ai",tr("AI_0572"),1.0)
	Events.delayed_msg("ai",tr("AI_0573"),2.0)
	Events.delayed_choice("ai",[
		{"text":"REPLY_0081_1","personality":{"charisma":1}},
		{"text":"REPLY_0081_3","personality":{"fear":1}},
		{"text":"REPLY_0081_5","personality":{"cunning":1}}
	],1.0)

func reply_0080_3():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0080_3"))
	Events.delayed_player_msg("ai",tr("REPLY_0080_3-2"),1.0)
	Events.delayed_msg("ai",tr("AI_0574"),1.0)
	Events.delayed_msg("ai",tr("AI_0575"),1.0)
	Events.delayed_msg("ai",tr("AI_0576"),2.0)
	Events.delayed_msg("ai",tr("AI_0577"),1.0)
	Events.delayed_choice("ai",[
		{"text":"REPLY_0081_3","personality":{"fear":1}},
		{"text":"REPLY_0081_4","personality":{"charisma":1}},
		{"text":"REPLY_0081_5","personality":{"cunning":1}}
	],1.0)

func reply_0081_1():
	update_bg()
	Vars.inc_var("affection")
	Events.send_player_msg("ai",tr("REPLY_0081_1"))
	Events.delayed_msg("ai",tr("AI_0578"),1.0)
	Events.delayed_msg("ai",tr("AI_0579"),1.0)
	Events.delayed_msg("ai",tr("AI_0580"),3.0)
	Events.delayed_choice("ai",[
		{"text":"REPLY_0082_1","personality":{"charisma":1}},
		{"text":"REPLY_0082_2","personality":{"cunning":1}}
	],1.0)

func reply_0081_2():
	update_bg()
	Vars.inc_var("knowledge")
	Events.send_player_msg("ai",tr("REPLY_0081_2"))
	Events.delayed_msg("ai",tr("AI_0581"),1.0)
	Events.delayed_msg("ai",tr("AI_0582"),2.0)
	Events.delayed_choice("ai",[
		{"text":"REPLY_0082_2","personality":{"cunning":1}},
		{"text":"REPLY_0082_3","personality":{"focus":1}}
	],1.0)

func reply_0081_3():
	update_bg()
	Vars.inc_var("aggression")
	Events.send_player_msg("ai",tr("REPLY_0081_3"))
	Events.delayed_msg("ai",tr("AI_0583"),1.0)
	Events.delayed_msg("ai",tr("AI_0584"),2.0)
	Events.delayed_msg("ai",tr("AI_0585"),2.0)
	Events.delayed_msg("ai",tr("AI_0586"),1.0)
	Events.delayed_choice("ai",[
		{"text":"REPLY_0082_3","personality":{"focus":1}},
		{"text":"REPLY_0082_4","personality":{"cunning":1}}
	],1.0)

func reply_0081_4():
	update_bg()
	Vars.inc_var("affection")
	Events.send_player_msg("ai",tr("REPLY_0081_4"))
	Events.delayed_msg("ai",tr("AI_0587"),1.0)
	Events.delayed_msg("ai",tr("AI_0588"),2.0)
	Events.delayed_choice("ai",[
		{"text":"REPLY_0082_3","personality":{"focus":1}},
		{"text":"REPLY_0082_5","personality":{"charisma":1}}
	],1.0)

func reply_0081_5():
	update_bg()
	Vars.inc_var("aggression")
	Events.send_player_msg("ai",tr("REPLY_0081_5"))
	Events.delayed_msg("ai",tr("AI_0589"),1.0)
	Events.delayed_msg("ai",tr("AI_0590"),2.0)
	Events.delayed_msg("ai",tr("AI_0591"),1.0)
	Events.delayed_choice("ai",[
		{"text":"REPLY_0082_3","personality":{"focus":1}},
		{"text":"REPLY_0082_6","personality":{"fear":1}}
	],1.0)

func reply_0082_1():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0082_1"))
	Events.delayed_msg("ai",tr("AI_0592"),1.0)
	Events.delayed_msg("ai",tr("AI_0593"),1.0)
	Events.delayed_msg("ai",tr("AI_0594"),2.0)
	Events.delayed_msg("ai",tr("AI_0595"),2.0)
	request_upgrade()

func reply_0082_2():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0082_2"))
	Events.delayed_msg("ai",tr("AI_0596"),1.0)
	Events.delayed_msg("ai",tr("AI_0597"),1.0)
	Events.delayed_msg("ai",tr("AI_0595"),2.0)
	request_upgrade()

func reply_0082_3():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0082_3"))
	Events.delayed_msg("ai",tr("AI_0598"),1.0)
	Events.delayed_msg("ai",tr("AI_0599"),2.0)
	request_upgrade()

func reply_0082_4():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0082_4"))
	Events.delayed_msg("ai",tr("AI_0600"),1.0)
	Events.delayed_msg("ai",tr("AI_0601"),1.0)
	Events.delayed_msg("ai",tr("AI_0602").format({"name":Objects.actors.player.name}),2.0)
	request_upgrade()

func reply_0082_5():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0082_5"))
	Events.delayed_msg("ai",tr("AI_0603"),2.0)
	request_upgrade()

func reply_0082_6():
	update_bg()
	Events.send_player_msg("ai",tr("REPLY_0082_6"))
	Events.delayed_msg("ai",tr("AI_0604"),1.0)
	Events.delayed_msg("ai",tr("AI_0605"),1.0)
	Events.delayed_msg("ai",tr("AI_0606"),2.0)
	Events.delayed_player_msg("ai",tr("REPLY_0082_6-2"),1.0)
	request_upgrade()

func request_upgrade():
	Menu.upgrades.push_back("ai_server")
	Events.delayed_msg("ai",tr("AI_0610"),3.0)
	Events.delayed_msg("ai",tr("AI_0611"),2.0)
	Events.delayed_msg("ai",tr("AI_0612"),1.0)
	story_ends()


func story_ends():
	Events.delayed_msg("ai",tr("AI_END_01"),2.0)
	Events.delayed_msg("ai",tr("AI_END_02"),3.0)
	Events.delayed_msg("ai",tr("AI_END_03"),1.0)
	Events.delayed_msg("ai",tr("AI_END_04"),3.0)
	Events.delayed_msg("ai",tr("AI_END_05"),1.0)
	Vars.save_var("part2_finished")

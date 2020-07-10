extends Node

func chat01():
	Events.delayed_msg("crypto",tr("CRYPTO_0001"),1.0)
	Events.delayed_choice("crypto",[
		{"text":"REPLY_0030_1","required":{"charisma":3}},
		{"text":"REPLY_0030_2","required":{"focus":3}},
		{"text":"REPLY_0030_3","required":{"cunning":3}}
	],2.0)
	Menu.add_log_msg("LOG_CRYPTO","LOG_MET_CRYPTO")
	Music.play("Of_Far_Different_Nature-Escape-10-Control.ogg",-4)

func reply_0030_1():
	Events.send_player_msg("crypto",tr("REPLY_0030_1"))
	Events.delayed_player_msg("crypto",tr("REPLY_0030_1-2"),1.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0002"),1.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0003"),2.0)
	Events.delayed_choice("crypto",[
		{"text":"REPLY_0031_1","required":{"curiosity":1}},
		{"text":"REPLY_0031_2","required":{"cunning":1}}
	],1.0)

func reply_0031_1():
	Events.send_player_msg("crypto",tr("REPLY_0031_1"))
	Events.delayed_msg("crypto",tr("CRYPTO_0004"),1.0)
	next_try()

func reply_0031_2():
	Events.send_player_msg("crypto",tr("REPLY_0031_2"))
	Events.delayed_msg("crypto",tr("CRYPTO_0005"),1.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0006"),3.0)
	next_try()

func reply_0030_2():
	Events.send_player_msg("crypto",tr("REPLY_0030_2-1").format({"name":Objects.actors.player.name}))
	Events.delayed_msg("crypto",tr("CRYPTO_0007").format({"name":Objects.actors.player.name}),2.0)
	Events.delayed_player_msg("crypto",tr("REPLY_0030_2-2"),1.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0008"),2.0)
	Events.delayed_choice("crypto",[
		{"text":"REPLY_0032_1","required":{"curiosity":1}},
		{"text":"REPLY_0032_2","required":{"charisma":1}}
	],1.0)

func reply_0032_1():
	Events.send_player_msg("crypto",tr("REPLY_0032_1"))
	Events.delayed_msg("crypto",tr("CRYPTO_0009"),1.0)
	Events.delayed_player_msg("crypto",tr("REPLY_0032_1-2"),2.0)
	Events.delayed_player_msg("crypto",tr("REPLY_0032_1-3"),2.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0010"),2.0)
	next_try()

func reply_0032_2():
	Events.send_player_msg("crypto",tr("REPLY_0032_2"))
	Events.delayed_player_msg("crypto",tr("REPLY_0032_2-2"),1.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0011"),1.0)
	Events.delayed_player_msg("crypto",tr("REPLY_0032_1-3"),2.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0010"),2.0)
	next_try()

func reply_0030_3():
	Events.send_player_msg("crypto",tr("REPLY_0030_3"))
	Events.delayed_player_msg("crypto",tr("REPLY_0030_3-2"),1.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0012"),1.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0013"),2.0)
	Events.delayed_choice("crypto",[
		{"text":"REPLY_0033_1","required":{"charisma":1}},
		{"text":"REPLY_0033_2","required":{"cunning":1}}
	],1.0)

func reply_0033_1():
	Events.send_player_msg("crypto",tr("REPLY_0033_1"))
	Events.delayed_player_msg("crypto",tr("REPLY_0033_1-2"),1.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0014"),2.0)
	next_try()

func reply_0033_2():
	Events.send_player_msg("crypto",tr("REPLY_0033_2"))
	Events.delayed_msg("crypto",tr("CRYPTO_0015"),1.0)
	Events.delayed_player_msg("crypto",tr("REPLY_0033_2-2"),2.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0016"),1.0)
	next_try()

func next_try():
	Events.delayed_choice("crypto",[
		{"text":"REPLY_0034_1","required":{"focus":3}},
		{"text":"REPLY_0034_2","required":{"cunning":3}},
		{"text":"REPLY_0034_3","required":{"fear":3}}
	],1.0)

func reply_0034_1():
	Events.send_player_msg("crypto",tr("REPLY_0034_1"))
	Events.delayed_msg("crypto",tr("CRYPTO_0020"),1.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0021"),1.0)
	Events.delayed_choice("crypto",[
		{"text":"REPLY_0035_1","required":{"charisma":1}},
		{"text":"REPLY_0035_2","required":{"curiosity":1}}
	],1.0)

func reply_0035_1():
	Events.send_player_msg("crypto",tr("REPLY_0035_1"))
	Events.delayed_msg("crypto",tr("CRYPTO_0022"),1.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0023"),2.0)
	abbort_try()

func reply_0035_2():
	Events.send_player_msg("crypto",tr("REPLY_0035_2"))
	Events.delayed_msg("crypto",tr("CRYPTO_0024"),1.0)
	Events.delayed_player_msg("crypto",tr("REPLY_0035_2-2"),2.0)
	abbort_try()

func reply_0034_2():
	Events.send_player_msg("crypto",tr("REPLY_0034_2"))
	Events.delayed_player_msg("crypto",tr("REPLY_0034_2-2"),1.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0025"),2.0)
	Events.delayed_choice("crypto",[
		{"text":"REPLY_0036_1","required":{"focus":1}},
		{"text":"REPLY_0036_2","required":{"curiosity":1}}
	],1.0)

func reply_0036_1():
	Events.send_player_msg("crypto",tr("REPLY_0036_1"))
	Events.delayed_msg("crypto",tr("CRYPTO_0026"),2.0)
	abbort_try()

func reply_0036_2():
	Events.send_player_msg("crypto",tr("REPLY_0036_2"))
	Events.delayed_player_msg("crypto",tr("REPLY_0036_2-2"),1.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0027"),2.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0028"),1.0)
	abbort_try()

func reply_0034_3():
	Events.send_player_msg("crypto",tr("REPLY_0034_3"))
	Events.delayed_player_msg("crypto",tr("REPLY_0034_2-2"),1.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0029"),3.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0030"),1.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0031"),2.0)
	Events.delayed_choice("crypto",[
		{"text":"REPLY_0037_1","required":{"curiosity":1}},
		{"text":"REPLY_0037_2","required":{"charisma":1}}
	],1.0)

func reply_0037_1():
	Events.send_player_msg("crypto",tr("REPLY_0037_1"))
	Events.delayed_player_msg("crypto",tr("REPLY_0037_1-2"),1.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0032"),2.0)
	abbort_try()

func reply_0037_2():
	Events.send_player_msg("crypto",tr("REPLY_0037_2"))
	Events.delayed_msg("crypto",tr("CRYPTO_0033"),1.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0034"),1.0)
	abbort_try()


func abbort_try():
	Events.delayed_player_msg("crypto",tr("REPLY_0038_1"),5.0)
	Events.delayed_player_msg("crypto",tr("REPLY_0038_2"),3.0)
	Events.delayed_player_msg("crypto",tr("REPLY_0038_3"),5.0)
	Events.delayed_method(14.0,"failed_communication_attempt")

func chat02():
	Events.delayed_method(6.0,"set_crypto_hally_talk")
	Events.delayed_player_msg("crypto",tr("AI_0360"),8.0,{"from_ally":"ai"})
	Events.delayed_player_msg("crypto",tr("AI_0361"),1.0,{"from_ally":"ai"})
	Events.delayed_msg("crypto",tr("CRYPTO_0040"),4.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0041"),1.0)
	Events.delayed_player_msg("crypto",tr("AI_0362"),3.0,{"from_ally":"ai"})
	Events.delayed_player_msg("crypto",tr("AI_0363"),2.0,{"from_ally":"ai"})
	Events.delayed_msg("crypto",tr("CRYPTO_0042"),4.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0043"),3.0)
	Events.delayed_player_msg("crypto",tr("AI_0364"),4.0,{"from_ally":"ai"})
	Events.delayed_player_msg("crypto",tr("AI_0365"),8.0,{"from_ally":"ai"})
	Events.delayed_msg("crypto",tr("CRYPTO_0044"),0.5)
	Events.delayed_player_msg("crypto",tr("AI_0366"),3.0,{"from_ally":"ai"})
	Events.delayed_method(1.0,"failed_communication_attempt2")
	
	Menu.add_log_msg("LOG_CRYPTO","LOG_MET_CRYPTO")
	Music.play("Of_Far_Different_Nature-Escape-10-Control.ogg",-4)



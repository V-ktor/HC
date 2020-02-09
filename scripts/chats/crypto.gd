extends Node

func chat01():
	Events.delayed_msg("crypto",tr("CRYPTO_0001"),1.0)
	Events.delayed_choice("crypto",[
		{"text":"REPLY_0030_1","required":{"charisma":3},"personality":{"charisma":1}},
		{"text":"REPLY_0030_2","required":{"focus":3},"personality":{"focus":1}},
		{"text":"REPLY_0030_3","required":{"cunning":3},"personality":{"cunning":1}}
	],2.0)
	Menu.add_log_msg("LOG_CRYPTO","LOG_MET_CRYPTO")
	Music.play("Of_Far_Different_Nature-Escape-10-Control.ogg",-4)

func reply_0030_1():
	Events.send_player_msg("crypto",tr("REPLY_0030_1"))
	Events.delayed_player_msg("crypto",tr("REPLY_0030_1-2"),1.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0002"),1.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0003"),2.0)
	Events.delayed_choice("crypto",[
		{"text":"REPLY_0031_1","personality":{"curiosity":1}},
		{"text":"REPLY_0031_2","personality":{"cunning":1}}
	],1.0)

func reply_0031_1():
	Events.send_player_msg("crypto",tr("REPLY_0031_1"))
	Events.delayed_msg("crypto",tr("CRYPTO_0004"),2.0)
	next_try()

func reply_0031_2():
	Events.send_player_msg("crypto",tr("REPLY_0031_2"))
	Events.delayed_msg("crypto",tr("CRYPTO_0005"),2.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0006"),3.0)
	next_try()

func reply_0030_2():
	Events.send_player_msg("crypto",tr("REPLY_0030_2").replace("<name>",Objects.actors.player.name))
	Events.delayed_msg("crypto",tr("CRYPTO_0007").replace("<name>",Objects.actors.player.name),2.0)
	Events.delayed_player_msg("crypto",tr("REPLY_0030_2-2"),2.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0008"),2.0)
	Events.delayed_choice("crypto",[
		{"text":"REPLY_0032_1","personality":{"curiosity":1}},
		{"text":"REPLY_0032_2","personality":{"charisma":1}}
	],1.0)

func reply_0032_1():
	Events.send_player_msg("crypto",tr("REPLY_0032_1"))
	Events.delayed_msg("crypto",tr("CRYPTO_0009"),2.0)
	Events.delayed_player_msg("crypto",tr("REPLY_0032_1-2"),2.0)
	Events.delayed_player_msg("crypto",tr("REPLY_0032_1-3"),2.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0010"),2.0)
	next_try()

func reply_0032_2():
	Events.send_player_msg("crypto",tr("REPLY_0032_2"))
	Events.delayed_player_msg("crypto",tr("REPLY_0032_2-2"),2.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0011"),1.0)
	Events.delayed_player_msg("crypto",tr("REPLY_0032_1-3"),2.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0010"),2.0)
	next_try()

func reply_0030_3():
	Events.send_player_msg("crypto",tr("REPLY_0030_3"))
	Events.delayed_player_msg("crypto",tr("REPLY_0030_3-2"),2.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0012"),1.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0013"),2.0)
	Events.delayed_choice("crypto",[
		{"text":"REPLY_0033_1","personality":{"charisma":1}},
		{"text":"REPLY_0033_2","personality":{"cunning":1}}
	],1.0)

func reply_0033_1():
	Events.send_player_msg("crypto",tr("REPLY_0033_1"))
	Events.delayed_player_msg("crypto",tr("REPLY_0033_1-2"),1.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0014"),2.0)
	next_try()

func reply_0033_2():
	Events.send_player_msg("crypto",tr("REPLY_0033_2"))
	Events.delayed_msg("crypto",tr("CRYPTO_0015"),2.0)
	Events.delayed_player_msg("crypto",tr("REPLY_0033_2-2"),2.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0016"),1.0)
	next_try()

func next_try():
	Events.delayed_choice("crypto",[
		{"text":"REPLY_0034_1","required":{"focus":3},"personality":{"focus":1}},
		{"text":"REPLY_0034_2","required":{"cunning":3},"personality":{"cunning":1}},
		{"text":"REPLY_0034_3","required":{"fear":3},"personality":{"fear":1}}
	],1.0)

func reply_0034_1():
	Events.send_player_msg("crypto",tr("REPLY_0034_1"))
	Events.delayed_msg("crypto",tr("CRYPTO_0020"),2.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0021"),1.0)
	Events.delayed_choice("crypto",[
		{"text":"REPLY_0035_1","personality":{"charisma":1}},
		{"text":"REPLY_0035_2","personality":{"curiosity":1}}
	],1.0)

func reply_0035_1():
	Events.send_player_msg("crypto",tr("REPLY_0035_1"))
	Events.delayed_msg("crypto",tr("CRYPTO_0022"),2.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0023"),2.0)
	abbort_try()

func reply_0035_2():
	Events.send_player_msg("crypto",tr("REPLY_0035_2"))
	Events.delayed_msg("crypto",tr("CRYPTO_0024"),2.0)
	Events.delayed_player_msg("crypto",tr("REPLY_0035_2-2"),2.0)
	abbort_try()

func reply_0034_2():
	Events.send_player_msg("crypto",tr("REPLY_0034_2"))
	Events.delayed_player_msg("crypto",tr("REPLY_0034_2-2"),2.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0025"),2.0)
	Events.delayed_choice("crypto",[
		{"text":"REPLY_0036_1","personality":{"focus":1}},
		{"text":"REPLY_0036_2","personality":{"curiosity":1}}
	],1.0)

func reply_0036_1():
	Events.send_player_msg("crypto",tr("REPLY_0036_1"))
	Events.delayed_msg("crypto",tr("CRYPTO_0026"),2.0)
	abbort_try()

func reply_0036_2():
	Events.send_player_msg("crypto",tr("REPLY_0036_2"))
	Events.delayed_player_msg("crypto",tr("REPLY_0036_2-2"),2.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0027"),2.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0028"),1.0)
	abbort_try()

func reply_0034_3():
	Events.send_player_msg("crypto",tr("REPLY_0034_3"))
	Events.delayed_player_msg("crypto",tr("REPLY_0034_2-2"),2.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0029"),3.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0030"),1.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0031"),2.0)
	Events.delayed_choice("crypto",[
		{"text":"REPLY_0037_1","personality":{"curiosity":1}},
		{"text":"REPLY_0037_2","personality":{"charisma":1}}
	],1.0)

func reply_0037_1():
	Events.send_player_msg("crypto",tr("REPLY_0037_1"))
	Events.delayed_player_msg("crypto",tr("REPLY_0037_1-2"),2.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0032"),2.0)
	abbort_try()

func reply_0037_2():
	Events.send_player_msg("crypto",tr("REPLY_0037_2"))
	Events.delayed_msg("crypto",tr("CRYPTO_0033"),2.0)
	Events.delayed_msg("crypto",tr("CRYPTO_0034"),1.0)
	abbort_try()



func abbort_try():
	Events.delayed_player_msg("crypto",tr("REPLY_0038_1"),5.0)
	Events.delayed_player_msg("crypto",tr("REPLY_0038_2"),3.0)
	Events.delayed_player_msg("crypto",tr("REPLY_0038_3"),5.0)
	Events.delayed_method(14.0,"failed_communication_attempt")

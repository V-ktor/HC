extends CanvasLayer

const VERSION = "v0.0-alpha"
const MAX_MSG = 100
const PROGRAM_ICONS = [
	"anti_virus_green","anti_virus_purple","beam_cannon","bombardment",
	"concentric_cyan","concentric_green","concentric_red",
	"phalanx_blue","phalanx_red","pulse_purple","pulse_yellow",
	"wave_green","wave_purple","probe_blue","probe_green","probe_red",
	"generator_blue","generator_purple","generator_orange","template"
]

var contacts := []
var targets := []
var decks := []
var chat_log := {}
var chat_read := {}
var chat_choice := {}
var chat_hack_log := []
var chat_hack_read := 0
var chat_hack_choice := []
var new_targets := 0
var active := false
var contact_selected
var target_selected
var deck_selected := 0
var save_files := []
var mode := ""
var building := []
var upgrades := []
var upgraded := {}
var compile_cpu := 0
var can_scan := false
var current_code := []
var new_line_pos := 0
var code_name
var code_icon
var game_instance
var program_icon_selected := 0

# warning-ignore:unused_class_variable
onready var textbox = $Textbox

var main_scene = preload("res://scenes/main/main.tscn")
var icon_shutdown = preload("res://images/gui/shutdown.png")
var icon_close = preload("res://images/gui/close.png")
var chat_box = preload("res://scenes/gui/chat_box.tscn")
var chat_choice_box = preload("res://scenes/gui/chat_choice.tscn")
var icons_personality = {
	"curiosity":preload("res://images/gui/magnifying_glass.png"),
	"fear":preload("res://images/gui/eye.png"),
	"charisma":preload("res://images/gui/charm.png"),
	"focus":preload("res://images/gui/focus.png"),
	"cunning":preload("res://images/gui/cunning.png")
}


func reset():
	var file = File.new()
	if game_instance!=null:
		game_instance.queue_free()
		game_instance = null
	active = false
	_close(true)
	contacts.clear()
	targets.clear()
	decks.clear()
	chat_log.clear()
	chat_read.clear()
	chat_choice.clear()
	upgrades.clear()
	upgraded.clear()
	new_targets = 0
	contact_selected = null
	target_selected = null
	deck_selected = 0
	mode = ""
	building.clear()
	compile_cpu = 0
	Objects.targets.clear()
	Objects.actors.clear()
	Objects.groups.clear()
	Objects.countries.clear()
	Objects.events.clear()
	Objects.targets.clear()
	Events.delayed.clear()
	Programs.known_programs.clear()
	Programs.known_commands.clear()
	$Left/ScrollContainer/VBoxContainer/Button0.visible = file.file_exists("user://saves/autosave.sav")
	$Left/ScrollContainer/VBoxContainer/Button1.show()
	$Left/ScrollContainer/VBoxContainer/Button3.hide()
	$Left/ScrollContainer/VBoxContainer/Button4.hide()
	$Left/ScrollContainer/VBoxContainer/Button5.hide()
	$Left/ScrollContainer/VBoxContainer/Button6.hide()
	$Left/ScrollContainer/VBoxContainer/Button7.hide()
	$Left/ScrollContainer/VBoxContainer/Button8.hide()
	$Left/ScrollContainer/VBoxContainer/Button9.hide()
	$Left/ScrollContainer/VBoxContainer/Button10.hide()
	$Left/ScrollContainer/VBoxContainer/Button11.show()
	Music.play_default()

func _start_new_game(name=null):
	var timer = Timer.new()
	if name==null:
		name = $Login/Input/LineEdit.text
	if name.length()<1:
		return false
	
	_close(true)
	reset()
	active = true
	new_targets = 0
	decks = [{"pulse":8}]
	
	$Login/Input/LineEdit.editable = false
	$Login/Input/ButtonConfirm.disabled = true
	$Left/ScrollContainer/VBoxContainer/Button0.disabled = true
	$Left/ScrollContainer/VBoxContainer/Button1.disabled = true
	$Left/ScrollContainer/VBoxContainer/Button2.disabled = true
	$Left/ScrollContainer/VBoxContainer/Button3.disabled = true
	$Top/HBoxContainer/ButtonClose.disabled = true
	$Login/HBoxContainer.show()
	$Login/HBoxContainer/AnimationPlayer.play("loading",-1,1.5)
	$Login.show()
	Objects.init_world(self)
	Programs.known_programs = {"pulse":Programs.programs.pulse}
	Programs.known_commands = [
		"// ","connect","disconnect","if","for","while","attack","sleep","return",
		"all_nodes","enemy_nodes","controled_nodes",
		"local","random_node","random_enemy","random_controled",
		"_true","enemy_adjacent","hostile_program_adjacent","controled_adjacent","==","!=",">","<",">=","<="
	]
	upgrades = ["cpu","memory","compile_cpu"]
	timer.one_shot = true
	timer.wait_time = 2.0
	add_child(timer)
	timer.start()
	
	yield(timer,"timeout")
	timer.queue_free()
	_close(true)
	$Left/ScrollContainer/VBoxContainer/Button0.hide()
	$Left/ScrollContainer/VBoxContainer/Button1.hide()
	$Left/ScrollContainer/VBoxContainer/Button2.show()
	$Left/ScrollContainer/VBoxContainer/Button3.show()
	$Left/ScrollContainer/VBoxContainer/Button4.show()
	$Left/ScrollContainer/VBoxContainer/Button5.hide()
	$Left/ScrollContainer/VBoxContainer/Button6.hide()
	$Left/ScrollContainer/VBoxContainer/Button8.hide()
	$Left/ScrollContainer/VBoxContainer/Button9.hide()
	$Left/ScrollContainer/VBoxContainer/Button11.hide()
	$Login/Input/LineEdit.editable = true
	$Login/Input/ButtonConfirm.disabled = false
	$Left/ScrollContainer/VBoxContainer/Button0.disabled = false
	$Left/ScrollContainer/VBoxContainer/Button1.disabled = false
	$Left/ScrollContainer/VBoxContainer/Button2.disabled = false
	$Left/ScrollContainer/VBoxContainer/Button3.disabled = false
	$Top/HBoxContainer/ButtonClose.disabled = false
	$Login/HBoxContainer.hide()
	$Login/HBoxContainer/AnimationPlayer.stop()
	
	Events.start()
	$Left/ScrollContainer/VBoxContainer/Button10.show()
	return true



func update_inventory():
	for c in $Deck/Inventory/HBoxContainer.get_children():
		c.hide()
	for prog in Objects.actors.player.programs.keys():
		var ci
		var number = 0
		if has_node("Deck/Inventory/HBoxContainer/"+prog):
			ci = get_node("Deck/Inventory/HBoxContainer/"+prog)
		else:
			var prgm = Programs.Program.new(Programs.programs[prog])
			var first_line = Programs.programs[prog].code[0]
			ci = $Deck/Deck/HBoxContainer/Card0.duplicate(0)
			ci.name = prog
			ci.get_node("Card/Image").set_texture(load("res://images/cards/"+Programs.programs[prog].icon+".png"))
			ci.get_node("Card/Name").text = tr(Programs.programs[prog].name)
			if "//" in first_line:
				ci.get_node("Card/Desc").text = first_line.substr(3,first_line.length()-3)
			else:
				ci.get_node("Card/Desc").text = ""
			ci.get_node("Card/Cpu").text = str(round(prgm.mean_cpu))+"("+str(prgm.max_cpu)+")"
			ci.get_node("Card/Size").text = str(prgm.size)
			get_node("Deck/Inventory/HBoxContainer").add_child(ci)
		if ci.get_node("Panel/HBoxContainer/ButtonAdd").is_connected("pressed",self,"_add_card"):
			ci.get_node("Panel/HBoxContainer/ButtonAdd").disconnect("pressed",self,"_add_card")
		ci.get_node("Panel/HBoxContainer/ButtonAdd").connect("pressed",self,"_add_card",[prog])
		if ci.get_node("Panel/HBoxContainer/ButtonSub").is_connected("pressed",self,"_remove_card"):
			ci.get_node("Panel/HBoxContainer/ButtonSub").disconnect("pressed",self,"_remove_card")
		ci.get_node("Panel/HBoxContainer/ButtonSub").connect("pressed",self,"_remove_card",[prog])
		if Objects.actors.player.programs.has(prog):
			number = Objects.actors.player.programs[prog]
		ci.get_node("Panel/HBoxContainer/Label").text = str(number)
		ci.rect_min_size.x = 0.7*get_node("Deck/Inventory/HBoxContainer").rect_size.y
		ci.show()
	
	connect_ui_sounds_recursively($Deck/Inventory/HBoxContainer)

func update_decks():
	var used = 0
	if decks.size()==0:
		decks.push_back({})
	for c in $Deck/HBoxContainer.get_children():
		c.pressed = false
		if c.name=="Add":
			continue
		if int(c.name)>decks.size():
			c.queue_free()
	for i in range(decks.size()-$Deck/HBoxContainer.get_child_count()+1):
		var ti = $Deck/HBoxContainer/Deck1.duplicate(0)
		ti.name = "Deck"+str(i+$Deck/HBoxContainer.get_child_count())
		ti.text = tr("DECK")+str(i+$Deck/HBoxContainer.get_child_count())
		ti.connect("pressed",self,"_select_deck",[i+$Deck/HBoxContainer.get_child_count()-1])
		$Deck/HBoxContainer.add_child(ti)
	$Deck/HBoxContainer/Add.raise()
	get_node("Deck/HBoxContainer/Deck"+str(deck_selected+1)).pressed = true
	for prog in decks[deck_selected].keys():
		var prgm = Programs.Program.new(Programs.programs[prog])
		used += prgm.size*decks[deck_selected][prog]
	$Deck/Memory.text = tr("MEMORY")+": "+str(Objects.actors.player.memory-used)+"/"+str(Objects.actors.player.memory)
	update_deck()

func update_deck():
	var used = 0
	for c in $Deck/Deck/HBoxContainer.get_children():
		c.hide()
	for prog in decks[deck_selected].keys():
		var ci
		if has_node("Deck/Deck/HBoxContainer/"+prog):
			ci = get_node("Deck/Deck/HBoxContainer/"+prog)
		else:
			var prgm = Programs.Program.new(Programs.programs[prog])
			var first_line = Programs.programs[prog].code[0]
			ci = $Deck/Deck/HBoxContainer/Card0.duplicate(0)
			ci.name = prog
			ci.get_node("Card/Image").set_texture(load("res://images/cards/"+Programs.programs[prog].icon+".png"))
			ci.get_node("Card/Name").text = tr(Programs.programs[prog].name)
			if "//" in first_line:
				ci.get_node("Card/Desc").text = first_line.substr(3,first_line.length()-3)
			else:
				ci.get_node("Card/Desc").text = ""
			ci.get_node("Card/Cpu").text = str(round(prgm.mean_cpu))+"("+str(prgm.max_cpu)+")"
			ci.get_node("Card/Size").text = str(prgm.size)
			$Deck/Deck/HBoxContainer.add_child(ci)
		if ci.get_node("Panel/HBoxContainer/ButtonAdd").is_connected("pressed",self,"_add_card"):
			ci.get_node("Panel/HBoxContainer/ButtonAdd").disconnect("pressed",self,"_add_card")
		ci.get_node("Panel/HBoxContainer/ButtonAdd").connect("pressed",self,"_add_card",[prog])
		if ci.get_node("Panel/HBoxContainer/ButtonSub").is_connected("pressed",self,"_remove_card"):
			ci.get_node("Panel/HBoxContainer/ButtonSub").disconnect("pressed",self,"_remove_card")
		ci.get_node("Panel/HBoxContainer/ButtonSub").connect("pressed",self,"_remove_card",[prog])
		ci.rect_min_size.x = 0.7*$Deck/Deck/HBoxContainer.rect_size.y
		ci.get_node("Panel/HBoxContainer/Label").text = str(decks[deck_selected][prog])
		ci.show()
	for prog in decks[deck_selected].keys():
		var prgm = Programs.Program.new(Programs.programs[prog])
		used += prgm.size*decks[deck_selected][prog]
	$Deck/Memory.text = tr("MEMORY")+": "+str(Objects.actors.player.memory-used)+"/"+str(Objects.actors.player.memory)
	connect_ui_sounds_recursively($Deck)

func update_main_menu():
	if !$Chat.visible:
		var total_unread = 0
		for c in chat_log.keys():
			total_unread += chat_log[c].size()-chat_read[c]
		$Left/ScrollContainer/VBoxContainer/Button4/Notice/Label.text = str(min(total_unread,9))
		$Left/ScrollContainer/VBoxContainer/Button4/Notice.visible = total_unread>0
	if $Chat.visible:
		for name in chat_log.keys():
			get_node("Chat/ScrollContainer/VBoxContainer/"+name+"/Notice/Label").text = str(chat_log[name].size()-chat_read[name])
			get_node("Chat/ScrollContainer/VBoxContainer/"+name+"/Notice").visible = chat_read[name]<chat_log[name].size()
		$Left/ScrollContainer/VBoxContainer/Button4/Notice.hide()
	if $Targets.visible:
		new_targets = 0
	if new_targets==0:
		$Left/ScrollContainer/VBoxContainer/Button8/Notice.hide()
	else:
		$Left/ScrollContainer/VBoxContainer/Button8/Notice/Label.text = str(min(new_targets,9))
		$Left/ScrollContainer/VBoxContainer/Button8/Notice.show()

func update_log():
	var tree = $Log/ScrollContainer/Tree
	tree.name = "deleted"
	tree.queue_free()
	tree = Tree.new()
	tree.name = "Tree"
	$Log/ScrollContainer.add_child(tree)
	tree.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tree.size_flags_vertical = Control.SIZE_EXPAND_FILL
	tree.connect("item_selected",self,"_log_item_selected")
	var root = tree.create_item()
	tree.set_hide_root(true)
	var child1 = tree.create_item(root)
	child1.set_text(0,tr("LOG"))
	child1.set_script(preload("res://scripts/gui/item.gd"))
	child1.type = "log"
	var child2 = tree.create_item(root)
	child2.set_text(0,tr("COMMANDS"))
	child2.set_script(preload("res://scripts/gui/item.gd"))
	child2.type = "command_overview"
	for i in range(Programs.known_commands.size()):
		var cmd = tree.create_item(child2)
		cmd.set_script(preload("res://scripts/gui/item.gd"))
		cmd.type = "command"
		cmd.ID = i
		cmd.set_text(0,Programs.known_commands[i])
	var child3 = tree.create_item(root)
	child3.set_text(0,tr("PERSONS"))
	child3.set_script(preload("res://scripts/gui/item.gd"))
	child3.type = "persons_overview"
	for k in Objects.actors.keys():
		var cmd = tree.create_item(child3)
		cmd.set_script(preload("res://scripts/gui/item.gd"))
		cmd.type = "person"
		cmd.ID = k
		cmd.set_text(0,tr(Objects.actors[k].name))
	var child4 = tree.create_item(root)
	child4.set_text(0,tr("GROUPS"))
	child4.set_script(preload("res://scripts/gui/item.gd"))
	child4.type = "groups_overview"
	var childs = {}
	for k in Objects.countries.keys():
		childs[k] = tree.create_item(child4)
		childs[k].set_script(preload("res://scripts/gui/item.gd"))
		childs[k].type = "groups_country"
		childs[k].ID = k
		childs[k].set_text(0,Objects.countries[k].name)
	for k in Objects.groups.keys():
		var cmd
		if !childs.has(Objects.groups[k].location):
			var nm = Objects.groups[k].location
			childs[nm] = tree.create_item(child4)
			childs[nm].set_script(preload("res://scripts/gui/item.gd"))
			childs[nm].type = "groups_country"
			childs[nm].ID = nm
			childs[nm].set_text(0,nm)
		cmd = tree.create_item(childs[Objects.groups[k].location])
		cmd.set_script(preload("res://scripts/gui/item.gd"))
		cmd.type = "group"
		cmd.ID = k
		cmd.set_text(0,Objects.groups[k].name)
	var child6 = tree.create_item(root)
	child6.set_text(0,tr("HISTORY"))
	child6.set_script(preload("res://scripts/gui/item.gd"))
	child6.type = "history_overview"
	for i in range(Objects.events.size()):
		var cmd = tree.create_item(child6)
		cmd.set_script(preload("res://scripts/gui/item.gd"))
		cmd.type = "event"
		cmd.ID = i
		cmd.set_text(0,tr(Objects.events[i].name))
	connect_ui_sounds_recursively($Log)


func _add_deck():
	decks.push_back({})
	deck_selected = decks.size()-1
	update_decks()

func _select_deck(deck):
	deck_selected = deck
	update_decks()

func get_memory():
	var used = 0
	for prog in decks[deck_selected].keys():
		var prgm = Programs.Program.new(Programs.programs[prog])
		used += prgm.size*decks[deck_selected][prog]
	return Objects.actors.player.memory-used

func _add_card(prog):
	var prgm = Programs.Program.new(Programs.programs[prog])
	if prgm.size>get_memory():
		return false
	var inventory = Objects.actors.player.programs
	if decks[deck_selected].has(prog):
		if decks[deck_selected][prog]>=inventory[prog]:
			return false
		else:
			decks[deck_selected][prog] += 1
	else:
		decks[deck_selected][prog] = 1
	update_deck()
	update_inventory()
	return true

func _remove_card(prog):
	if !decks[deck_selected].has(prog):
		return false
	if decks[deck_selected][prog]==1:
		decks[deck_selected].erase(prog)
	else:
		decks[deck_selected][prog] -= 1
	update_deck()
	update_inventory()
	return true

func _select_contact(contact):
	var bg = load(Objects.actors[contact].bg).instance()
	var portrait = load(Objects.actors[contact].portrait).instance()
	var scale = max($Chat/Panel/Portrait.rect_size.x/portrait.get_node("Rect").rect_size.x,$Chat/Panel/Portrait.rect_size.y/portrait.get_node("Rect").rect_size.y)
	contact_selected = contact
	$Chat/Panel/Tween.interpolate_property($Chat/Panel,"self_modulate",$Chat/Panel.self_modulate,Objects.actors[contact].color,0.5,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Chat/Panel/Tween.start()
	if has_node("Chat/Panel/BG"):
		$Chat/Panel/BG/AnimationPlayer.play("fade_out")
		$Chat/Panel/BG.name = "deleted"
	bg.name = "BG"
	$Chat/Panel.add_child(bg)
	for c in $Chat/Panel/Portrait.get_children():
		c.queue_free()
	portrait.scale = Vector2(scale,scale)
	portrait.position = (scale*portrait.get_node("Rect").rect_size-$Chat/Panel/Portrait.rect_size)*Vector2(-0.33,0.5)
	$Chat/Panel/Portrait.add_child(portrait)
	$Chat/Panel/Portrait.raise()
	$Chat/Panel/ScrollContainer.raise()
	get_node("Chat/ScrollContainer/VBoxContainer/"+contact+"/Notice").hide()
	$Top/HBoxContainer/Title.text = tr("CHAT")+" - "+tr(Objects.actors[contact].name)
	update_chat()

func _select_choice(choice,index,panel):
	var method = choice.text.to_lower()
	panel.queue_free()
	chat_log[contact_selected].remove(index)
	if choice.has("personality"):
		for k in choice.personality.keys():
			Objects.actors.player.personality[k] += choice.personality[k]
	if Events.has_method(method):
		Events.call(method)
		update_chat()
	else:
		Events.call_chat(contact_selected,method)

func _select_target(target):
	var tg = Objects.targets[target]
	var group = tg.group
	var text := $Targets/VBoxContainer/HBoxContainer/Text
	var text_right := $Targets/VBoxContainer/HBoxContainer/Text
	target_selected = target
	$Targets/Panel/Tween.interpolate_property($Targets/Panel,"self_modulate",$Targets/Panel.self_modulate,tg.color,0.5,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Targets/Panel/Tween.interpolate_property($Targets/Panel,"modulate",$Targets/Panel.modulate,Color(1,1,1,1),0.5,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Targets/Panel/Tween.start()
	$Targets/Panel/Label.text = tr(tg.desc)
	$Top/HBoxContainer/Title.text = tr("WEB")+" - "+tr(tg.name)
	text_right.clear()
	if group!=null:
		update_logo(Objects.groups[group].logo)
		$Targets/VBoxContainer/HBoxContainer/Logo.texture = $ViewportLogo.get_texture()
		text_right.push_color(Objects.groups[group].color)
		text_right.add_text(Objects.groups[group].name)
		text_right.push_color(Color(1,1,1))
		text_right.newline()
		text_right.add_text(" - "+Objects.groups[group].form+" - ")
		text.clear()
		Objects.groups[group].print_desc(text)

func _attack_target():
	if target_selected==null:
		return false
	printt("Initializing attack...")
	
	var mi = main_scene.instance()
	var target = Objects.targets[target_selected]
	var player = Objects.actors.player
	game_instance = mi
	get_tree().get_root().add_child(mi)
	_show_hack()
	Events._on_hack_started(target_selected)
	mi.connect("timeout",self,"_hack_ended")
	mi.start(2,player.time_limit,[player.cpu,target.cpu],[decks[deck_selected].duplicate(),target.programs.duplicate()],["human",target.ai],[player.color,target.color],mi.callv("create_"+target.layout+"_system",target.layout_params))
	Music.play_action()
	
	chat_hack_choice.clear()
	chat_hack_log.clear()
	chat_hack_read = 0
	return true

func _hack_ended(winner):
	var status = ["DRAW","VICTORY","LOST"][min(winner+1,2)]
	if game_instance!=null:
		game_instance.queue_free()
		game_instance = null
	for c in $Hack/Panel/ScrollContainer/VBoxContainer.get_children():
		c.queue_free()
	if winner==0:
		Objects.actors.player.credits += Objects.targets[target_selected].credits
		Objects.actors.player.rating += Objects.targets[target_selected].prestige
		$Hack/Result/LabelReward.text = tr("CREDITS")+": +"+str(Objects.targets[target_selected].credits)+"\n"+tr("RANKING")+": +"+str(Objects.targets[target_selected].prestige)+"\n"
		add_log_msg(tr("LOG_HACK_SUCCESS")%Objects.targets[target_selected].name)
		if randf()<0.25:
			var type = Objects.targets[target_selected].programs.keys()[randi()%Objects.targets[target_selected].programs.size()]
			if !Objects.actors.player.programs.has(type):
				Objects.actors.player.programs[type] = 1
				add_log_msg(tr("LOG_NEW_PROGRAM_ACQUIRED").replace("%s",tr(Programs.programs[type].name)),tr("LOG_NEW_PROGRAM_ACQUIRED").replace("%s",tr(Programs.programs[type].name)))
				Events._on_gained_tech(type)
			else:
				Objects.actors.player.programs[type] += 1
			$Hack/Result/LabelReward.text += tr("TECHS")+": "+tr(Programs.programs[type].name)+"\n"
	elif winner==1:
		Objects.actors.player.rating = max(Objects.actors.player.rating-floor(Objects.targets[target_selected].prestige/2),0)
		$Hack/Result/LabelReward.text = tr("RANKING")+": -"+str(floor(Objects.targets[target_selected].prestige/2))+"\n"
		add_log_msg(tr("LOG_HACK_FAILED").replace("%s",Objects.targets[target_selected].name),tr("LOG_HACK_FAILED").replace("%s",Objects.targets[target_selected].name))
	else:
		$Hack/Result/LabelReward.text = ""
	Music.play_default()
	Events._on_hack_ended(winner==0,Objects.targets[target_selected])
	
	$Hack/Panel/Text.clear()
	if winner==0:
		var portrait = preload("res://scenes/portraits/character01.tscn").instance()
		var scale = max($Hack/Panel/Portrait.rect_size.x/portrait.get_node("Rect").rect_size.x,$Hack/Panel/Portrait.rect_size.y/portrait.get_node("Rect").rect_size.y)
		if Objects.targets[target_selected].group!=null:
			var gr = Objects.groups[Objects.targets[target_selected].group]
			var files := Objects.create_data(gr)
			var directory := Objects.get_directory(gr)
			var user : String = Objects.actors.player.name+"@"+OS.get_model_name()+": "
			var data := 0
			Events._on_create_hack_files(Objects.targets[target_selected],files)
			$Hack/Panel/Text.push_color(Color(0.1,1.0,0.1))
			$Hack/Panel/Text.add_text(user)
			$Hack/Panel/Text.push_color(Color(1.0,1.0,1.0))
			$Hack/Panel/Text.add_text(":~/"+directory+"$ls -l\n")
			for dict in files:
				$Hack/Panel/Text.add_text("-rw-rw-r-- "+str(int(dict.size*1024)).pad_zeros(12)+" ")
				$Hack/Panel/Text.add_text(dict.name+"\n")
				data += dict.size
			$Hack/Panel/Text.push_color(Color(0.1,1.0,0.1))
			$Hack/Panel/Text.add_text(user)
			$Hack/Panel/Text.push_color(Color(1.0,1.0,1.0))
			$Hack/Panel/Text.add_text(":~/"+directory+"$")
			gr.data += data
			$Hack/Result/LabelReward.text += tr("DATA")+": "+get_data_str(data)
		else:
			var user : String = Objects.actors.player.name+"@"+OS.get_model_name()+": "
			$Hack/Panel/Text.push_color(Color(0.1,1.0,0.1))
			$Hack/Panel/Text.add_text(user)
			$Hack/Panel/Text.push_color(Color(1.0,1.0,1.0))
			$Hack/Panel/Text.add_text(":~/$")
		for c in $Hack/Panel/Portrait.get_children():
			c.queue_free()
		portrait.scale = Vector2(scale,scale)
		portrait.position = (scale*portrait.get_node("Rect").rect_size-$Chat/Panel/Portrait.rect_size)*Vector2(0.5,0.33)
		$Hack/Panel/Portrait.add_child(portrait)
	
	$Hack.show()
	$Hack/Panel.show()
	$Hack/Result.show()
	$Hack/Result/LabelStatus.text = tr(status)
	$Top/HBoxContainer/Title.text = tr("HACK_"+status)
	Objects.trigger_on_win(winner==0)

func _confirm_hack_result():
	$Hack/Result.hide()
#	_close(true)
#	if has_node("/root/Main"):
#		$"/root/Main".queue_free()

func add_msg(contact,text,from_player=false):
	if !chat_log.has(contact):
		chat_log[contact] = [{"text":text,"from_player":from_player}]
	else:
		chat_log[contact].push_back({"text":text,"from_player":from_player})
	if !chat_read.has(contact):
		chat_read[contact] = 0
		chat_choice[contact] = []
	if chat_log[contact].size()>MAX_MSG:
		chat_log[contact].pop_front()
		chat_read[contact] -= 1
	if $Chat.visible:
		if contact_selected==contact:
			update_chat()
	update_main_menu()

func add_choice(contact,choices):
	if !chat_choice.has(contact):
		chat_choice[contact] = [{"choices":choices,"from_player":true}]
	else:
		chat_log[contact].push_back({"choices":choices,"from_player":true})
	if !chat_read.has(contact):
		chat_read[contact] = 0
		chat_choice[contact] = []
	if chat_log[contact].size()>MAX_MSG:
		chat_log[contact].pop_front()
		chat_read[contact] -= 1
	if $Chat.visible:
		if contact_selected==contact:
			update_chat()
	update_main_menu()

func add_hack_msg(text,from_player=false):
	chat_hack_log.push_back({"text":text,"from_player":from_player})
	if chat_hack_log.size()>MAX_MSG:
		chat_hack_log.pop_front()
		chat_hack_read -= 1
	if $Hack.visible:
		update_hack_chat()
	update_main_menu()

func remove_choice(contact,choices):
	if !chat_choice.has(contact):
		chat_choice[contact] = []
	else:
		for i in range(chat_choice[contact].size()-1,-1,-1):
			var c = chat_choice[contact][i]
			if c.text in choices:
				chat_choice[contact].remove(i)
	if $Chat.visible && contact==contact_selected:
		update_chat()

func add_tech(prog):
	if prog in Programs.known_programs.keys():
		return
	Programs.known_programs[prog] = Programs.programs[prog]
	if $Compile.visible:
		update_compile()

func _research(prog):
#	if Objects.actors.player.programs[prog]<1:
#		return false
	var prgm = Programs.Program.new(Programs.programs[prog])
	if Programs.known_programs.has(prog):
		if prgm.cost>Objects.actors.player.credits || prgm.compile_cpu>Objects.actors["ai"].cpu-compile_cpu:
			return false
		Objects.actors.player.credits -= prgm.cost
		building.push_back({"type":prog,"method":"add_program","delay":prgm.compile_time,"time":prgm.compile_time,"cpu":prgm.compile_cpu,"name":Programs.programs[prog].name,"icon":"res://images/cards/"+Programs.programs[prog].icon+".png"})
	else:
		if 2*prgm.cost>Objects.actors.player.credits || 2*prgm.compile_cpu>Objects.actors["ai"].cpu-compile_cpu:
			return false
		for dict in building:
			if dict["type"]==prog:
				return false
		Objects.actors.player.credits -= 2*prgm.cost
		building.push_back({"type":prog,"method":"research","delay":2*prgm.compile_time,"time":2*prgm.compile_time,"cpu":2*prgm.compile_cpu,"name":Programs.programs[prog].name,"icon":"res://images/cards/"+Programs.programs[prog].icon+".png"})
	update_compile()
	return true

func research(dict):
	var prgm = Programs.programs[dict.type]
	Objects.actors.player.programs[dict.type] -= 1
	Programs.known_programs[dict.type] = prgm
	Events._on_decompile(dict.type)
	add_log_msg(tr("LOG_PROGRAM_DECOMPLIED")%tr(prgm.name),tr("LOG_PROGRAM_DECOMPLIED")%tr(prgm.name))
	for cmd in Programs.COMMANDS.keys()+Programs.STATEMENTS+Programs.SETS+Programs.TARGETS:
		if cmd in Programs.known_commands:
			continue
		for line in prgm.code:
			if cmd in line:
				Programs.known_commands.push_back(cmd)
				add_log_msg(tr("LOG_COMMAND_LEARNED")%cmd,tr("LOG_COMMAND_LEARNED")%cmd)
				continue

func _upgrade(tech):
	var lvl = 1
	if upgraded.has(tech):
		lvl += upgraded[tech]
	if Upgrades.upgrades[tech].compile_cpu>Objects.actors["ai"].cpu-compile_cpu || Upgrades.upgrades[tech].cost>Objects.actors.player.credits:
		return false
	for dict in building:
		if dict["type"]==tech:
			return false
	Objects.actors.player.credits -= lvl*Upgrades.upgrades[tech].cost
	building.push_back({"type":tech,"method":"upgrade","delay":lvl*Upgrades.upgrades[tech].compile_time,"time":lvl*Upgrades.upgrades[tech].compile_time,"cpu":Upgrades.upgrades[tech].compile_cpu,"name":Upgrades.upgrades[tech].name,"icon":Upgrades.upgrades[tech].icon})
	update_upgrades()
	return true

func upgrade(dict):
	if upgraded.has(dict["type"]):
		upgraded[dict["type"]] += 1
	else:
		upgraded[dict["type"]] = 1
	Upgrades.call(Upgrades.upgrades[dict["type"]]["method"],Upgrades.upgrades[dict["type"]]["args"])

func add_chat_box(dict,index,where="Chat"):
	if dict.has("choices"):
		add_chat_choice_box(dict.choices,index)
		return
	
	var text = dict.text
	var from_player = dict.from_player
	var bi = chat_box.instance()
	var l = text.length()
	var width = max(min(256+floor(sqrt(l/8))*48,get_node(where+"/Panel/ScrollContainer/VBoxContainer").rect_size.x-256),384)
	var height = 48+floor(l*14/width)*32
	bi.get_node("Panel/Label").text = text
	bi.get_node("Panel").rect_min_size = Vector2(width,height)
	if from_player:
		bi.get_node("Control").raise()
	if !from_player:
		var stylebox = bi.get_node("Panel").get_stylebox("panel").duplicate()
		stylebox.border_color = Objects.actors["ai"].color
		bi.get_node("Panel").add_stylebox_override("panel",stylebox)
	get_node(where+"/Panel/ScrollContainer/VBoxContainer").add_child(bi)

func add_chat_choice_box(choices,index,where="Chat"):
	var available := 0
	var bi = chat_choice_box.instance()
	bi.get_node("Panel").rect_min_size.y = 48+44*(choices.size()-1)
	for c in choices:
		var button = bi.get_node("Panel/VBoxContainer/Button0").duplicate(Node.DUPLICATE_SCRIPTS)
		button.get_node("HBoxContainer/Label").text = tr(c.text)
		if c.has("required") && c.required.size()>0:
			button.get_node("HBoxContainer/Icon").texture = icons_personality[c.required.keys()[0]]
			for k in c.required.keys():
				if Objects.actors.player.personality[k]<c.required[k]:
					button.disabled = true
		elif c.has("personality") && c.personality.size()>0:
			button.get_node("HBoxContainer/Icon").texture = icons_personality[c.personality.keys()[0]]
		available += int(!button.disabled)
		bi.get_node("Panel/VBoxContainer").add_child(button)
		button.connect("pressed",self,"_select_choice",[c,index,bi])
		button.show()
	if available==0:
		# Make the first choice available if none are valid.
		bi.get_node("Panel/VBoxContainer").get_child(0).disabled = false
	get_node(where+"/Panel/ScrollContainer/VBoxContainer").add_child(bi)

func update_chat():
	for c in $Chat/Panel/ScrollContainer/VBoxContainer.get_children():
		c.queue_free()
	if !chat_read.has(contact_selected) || !chat_log.has(contact_selected) || !chat_choice.has(contact_selected):
		chat_read[contact_selected] = 0
		chat_log[contact_selected] = []
		chat_choice[contact_selected] = []
	for i in range(min(chat_read[contact_selected],chat_log[contact_selected].size())):
		add_chat_box(chat_log[contact_selected][i],i)
	if chat_read[contact_selected]<chat_log[contact_selected].size():
		var li = Label.new()
		li.text = " - "+tr("NEW_MESSAGES")+" - "
		$Chat/Panel/ScrollContainer/VBoxContainer.add_child(li)
	for i in range(chat_read[contact_selected],chat_log[contact_selected].size()):
		add_chat_box(chat_log[contact_selected][i],i)
	
	$Chat/Panel/ScrollContainer.scroll_vertical = 10.0*$Chat/Panel/ScrollContainer.rect_size.y
	update_main_menu()
	yield(get_tree(),"idle_frame")
	$Chat/Panel/ScrollContainer.scroll_vertical = 10.0*$Chat/Panel/ScrollContainer.rect_size.y
	connect_ui_sounds_recursively($Chat)

func update_hack_chat():
	for c in $Hack/Panel/ScrollContainer/VBoxContainer.get_children():
		c.queue_free()
	for i in range(min(chat_hack_read,chat_hack_log.size())):
		add_chat_box(chat_hack_log[i],i,"Hack")
	for i in range(chat_hack_read,chat_hack_log.size()):
		add_chat_box(chat_hack_log[i],i,"Hack")
	
	$Hack/Panel/ScrollContainer.scroll_vertical = 2.0*$Hack/Panel/ScrollContainer.rect_size.y
	update_main_menu()
	yield(get_tree(),"idle_frame")
	$Hack/Panel/ScrollContainer.scroll_vertical = 2.0*$Hack/Panel/ScrollContainer.rect_size.y
	connect_ui_sounds_recursively($Hack)

func update_upgrades():
	compile_cpu = 0
	for c in $Gear/Techs/HBoxContainer.get_children():
		c.hide()
	for c in $Gear/ScrollContainer/GridContainer.get_children():
		c.hide()
	for i in range(upgrades.size()):
		var ci
		var lvl = 1
		if upgraded.has(upgrades[i]):
			lvl += upgraded[upgrades[i]]
		if has_node("Gear/Techs/HBoxContainer/Tech"+str(i)):
			ci = get_node("Gear/Techs/HBoxContainer/Tech"+str(i))
		else:
			ci = $Gear/Techs/HBoxContainer/Tech0.duplicate(0)
			ci.name = upgrades[i]
			$Gear/Techs/HBoxContainer.add_child(ci)
		ci.get_node("Card/Image").set_texture(load(Upgrades.upgrades[upgrades[i]]["icon"]))
		ci.get_node("Card/Name").text = tr(Upgrades.upgrades[upgrades[i]]["name"])
		ci.get_node("Card/Desc").text = tr(Upgrades.upgrades[upgrades[i]]["name"]+"_DESC")%Upgrades.upgrades[upgrades[i]]["args"]
		ci.get_node("Card/Cpu").text = str(Upgrades.upgrades[upgrades[i]]["compile_cpu"])
		ci.get_node("Card/Size").text = str(lvl)
		if ci.get_node("Button").is_connected("pressed",self,"_upgrade"):
			ci.get_node("Button").disconnect("pressed",self,"_upgrade")
		ci.get_node("Button").connect("pressed",self,"_upgrade",[upgrades[i]])
		ci.rect_min_size.x = 0.7*$Gear/Techs/HBoxContainer.rect_size.y
		ci.get_node("Button").text = tr("RESEARCH")
		ci.get_node("Label").text = tr("COST")+": "+str(lvl*Upgrades.upgrades[upgrades[i]].cost)+"\n"+tr("CPU")+": "+str(Upgrades.upgrades[upgrades[i]].compile_cpu)+"\n"+tr("TIME")+": "+str(lvl*Upgrades.upgrades[upgrades[i]].compile_time)
		ci.show()
	for i in range(building.size()):
		var si
		if has_node("Gear/ScrollContainer/GridContainer/Stack"+str(i)):
			si = get_node("Gear/ScrollContainer/GridContainer/Stack"+str(i))
		else:
			si = $Gear/ScrollContainer/GridContainer/Stack0.duplicate()
			si.name = "Stack"+str(i)
			$Gear/ScrollContainer/GridContainer.add_child(si)
		si.show()
		si.get_node("Label").text = tr(building[i]["name"])
		si.get_node("Icon").texture = load(building[i]["icon"])
		si.get_node("ProgressBar").max_value = building[i]["time"]
		compile_cpu += building[i]["cpu"]
	$Gear/CPU.text = tr("CPU")+": "+str(Objects.actors["ai"].cpu-compile_cpu)+"/"+str(Objects.actors["ai"].cpu)
	$Gear/Credits.text = tr("CREDITS")+": "+str(Objects.actors.player.credits)
	connect_ui_sounds_recursively($Gear)

func update_compile():
	var all_programs = Objects.actors.player.programs.duplicate()
	for p in Programs.known_programs.keys():
		if !all_programs.has(p):
			all_programs[p] = 0
	compile_cpu = 0
	for c in $Compile/Techs/HBoxContainer.get_children():
		c.hide()
	for c in $Compile/ScrollContainer/GridContainer.get_children():
		c.hide()
	for i in range(all_programs.size()):
		var ci
		var type = all_programs.keys()[i]
		var prog = Programs.programs[type]
		var prgm = Programs.Program.new(prog)
		var first_line = prog.code[0]
		if has_node("Compile/Techs/HBoxContainer/Tech"+str(i)):
			ci = get_node("Compile/Techs/HBoxContainer/Tech"+str(i))
		else:
			ci = $Compile/Techs/HBoxContainer/Tech0.duplicate(0)
			ci.name = prog.name
			$Compile/Techs/HBoxContainer.add_child(ci)
		ci.get_node("Card/Image").set_texture(load("res://images/cards/"+prog.icon+".png"))
		ci.get_node("Card/Name").text = tr(prog.name)
		if "//" in first_line:
			ci.get_node("Card/Desc").text = first_line.substr(3,first_line.length()-3)
		else:
			ci.get_node("Card/Desc").text = ""
		ci.get_node("Card/Cpu").text = str(round(prgm.mean_cpu))+"("+str(prgm.max_cpu)+")"
		ci.get_node("Card/Size").text = str(prgm.size)
		if ci.get_node("Button").is_connected("pressed",self,"_research"):
			ci.get_node("Button").disconnect("pressed",self,"_research")
		ci.get_node("Button").connect("pressed",self,"_research",[type])
		ci.rect_min_size.x = 0.7*$Compile/Techs/HBoxContainer.rect_size.y
		if Programs.known_programs.has(type):
			ci.get_node("Button").text = tr("COMPILE")
			ci.get_node("Label").text = tr("COST")+": "+str(prgm.cost)+"\n"+tr("CPU")+": "+str(prgm.compile_cpu)+"\n"+tr("TIME")+": "+str(prgm.compile_time)
		else:
			ci.get_node("Button").text = tr("DECOMPILE")
			ci.get_node("Label").text = tr("COST")+": "+str(2*prgm.cost)+"\n"+tr("CPU")+": "+str(2*prgm.compile_cpu)+"\n"+tr("TIME")+": "+str(2*prgm.compile_time)
		ci.show()
	for i in range(building.size()):
		var si
		if has_node("Compile/ScrollContainer/GridContainer/Stack"+str(i)):
			si = get_node("Compile/ScrollContainer/GridContainer/Stack"+str(i))
		else:
			si = $Compile/ScrollContainer/GridContainer/Stack0.duplicate()
			si.name = "Stack"+str(i)
			$Compile/ScrollContainer/GridContainer.add_child(si)
		si.show()
		si.get_node("Label").text = tr(building[i]["name"])
		si.get_node("Icon").texture = load(building[i]["icon"])
		si.get_node("ProgressBar").max_value = building[i]["time"]
		compile_cpu += building[i]["cpu"]
	$Compile/CPU.text = tr("CPU")+": "+str(Objects.actors["ai"].cpu-compile_cpu)+"/"+str(Objects.actors["ai"].cpu)
	$Compile/Credits.text = tr("CREDITS")+": "+str(Objects.actors.player.credits)
	connect_ui_sounds_recursively($Compile)

func add_program(dict):
	if Objects.actors.player.programs.has(dict["type"]):
		Objects.actors.player.programs[dict["type"]] += 1
	else:
		Objects.actors.player.programs[dict["type"]] = 1

func update_code():
	for c in $Code/Code/VBoxContainer.get_children():
		c.hide()
	for c in $Code/ScrollContainer/VBoxContainer.get_children():
		c.hide()
	if has_node("Code/PopupMenu"):
		var popup_menu = $Code/PopupMenu
		popup_menu.name = "deleted"
		popup_menu.queue_free()
	for i in range(Programs.known_programs.size()):
		var button
		if has_node("Code/ScrollContainer/VBoxContainer/Button"+str(i)):
			button = get_node("Code/ScrollContainer/VBoxContainer/Button"+str(i))
		else:
			button = get_node("Code/ScrollContainer/VBoxContainer/Button0").duplicate(Node.DUPLICATE_SCRIPTS)
			button.name = "Button"+str(i)
			button.connect("pressed",self,"_load_program",[i])
			get_node("Code/ScrollContainer/VBoxContainer").add_child(button)
		button.text = tr(Programs.known_programs.values()[i].name)
		button.get_node("Icon").texture = load("res://images/cards/"+Programs.known_programs.values()[i].icon+".png")
		button.show()
	var popup_menu = PopupMenu.new()
	popup_menu.name = "PopupMenu"
	$Code.add_child(popup_menu)
	for i in range(Programs.known_commands.size()):
		var c = Programs.known_commands[i]
		if c in Programs.MAIN_COMMANDS:
			popup_menu.add_item(c,i)
	popup_menu.connect("id_pressed",self,"_add_new_line")
	update_program()
	connect_ui_sounds_recursively($Code)

func _load_program(ID):
	current_code = Programs.known_programs.values()[ID].code.duplicate(true)
	code_name = Programs.known_programs.keys()[ID]
	code_icon = Programs.known_programs.values()[ID].icon
	$Code/Code/VBoxContainer/Name.text = code_name
	update_program()

func _save_program():
	if code_name in Programs.programs.keys():
		var n = 2
		while code_name+" "+str(n) in Programs.known_programs.keys():
			n += 1
		code_name += " "+str(n)
	Programs.programs[code_name] = {"name":code_name,"code":current_code,"icon":code_icon}
	Programs.known_programs[code_name] = Programs.programs[code_name]
	update_code()

func _new_program():
	current_code = ["// "+tr("ADD_COMMENT")]
	code_name = "new program"
	code_icon = "template"
	$Code/Code/VBoxContainer/Name.text = code_name
	update_program()

func _delete_program():
	if Programs.predefined_programs.has(code_name):
		return
	Programs.known_programs.erase(code_name)
	update_code()

func _select_program_icon(ID):
	program_icon_selected = ID
	code_icon = PROGRAM_ICONS[ID]
	$Code/Icon.hide()

func _set_program_icon():
	code_icon = PROGRAM_ICONS[program_icon_selected]

func _set_code_name(text):
	if text in Programs.programs.keys():
		return
	code_name = text

func update_program():
	var intend = 0
	var prgm = Programs.Program.new({"code":current_code})
	if current_code.size()==0 || !("return" in current_code[current_code.size()-1]):
		current_code.push_back("return")
	for c in $Code/Code/VBoxContainer.get_children():
		c.hide()
	$Code/Code/VBoxContainer/Name.show()
	for i in range(current_code.size()):
		var button
		var line
		if has_node("Code/Code/VBoxContainer/Add"+str(i)):
			button = get_node("Code/Code/VBoxContainer/Add"+str(i))
		else:
			button = get_node("Code/Code/VBoxContainer/Add0").duplicate(Node.DUPLICATE_SCRIPTS)
			button.connect("pressed",self,"_add_line",[i])
			button.name = "Add"+str(i)
			get_node("Code/Code/VBoxContainer").add_child(button)
		if has_node("Code/Code/VBoxContainer/Line"+str(i)):
			line = get_node("Code/Code/VBoxContainer/Line"+str(i))
		else:
			line = get_node("Code/Code/VBoxContainer/Line0").duplicate(Node.DUPLICATE_SCRIPTS)
			line.get_node("ButtonDelete").connect("pressed",self,"_delete_line",[i])
			line.name = "Line"+str(i)
			get_node("Code/Code/VBoxContainer").add_child(line)
		if !"//" in current_code[i] && ("end" in current_code[i] || "elif" in current_code[i] || "else" in current_code[i]):
			intend -= 1
		line.get_node("Number").text = str(i+1)+":"
		line.get_node("Text").text = ""
		for _j in range(intend):
			line.get_node("Text").text += "    "
		for c in line.get_node("Args").get_children():
			c.queue_free()
		if "//" in current_code[i]:
			line.get_node("Text").text += "// "
			var li = LineEdit.new()
			li.text = tr(current_code[i].replace("// ",""))
			li.connect("text_entered",self,"_set_comment",[i])
			li.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			li.anchor_right = 1.0
			li.margin_right = 0
			line.get_node("Args").add_child(li)
		else:
			var array = current_code[i].split(" ",false)
			line.get_node("Text").text += array[0]
			for j in range(1,array.size()):
				var v = str2var(array[j])
				if typeof(v)==TYPE_INT || typeof(v)==TYPE_REAL:
					var bi = OptionButton.new()
					var si = SpinBox.new()
					var vars = Programs.VARS+get_vars(i)
					si.connect("value_changed",self,"_set_arg",[i,j])
					si.value = v
					si.min_value = 1
					for k in range(vars.size()):
						bi.add_item(tr(vars[k].to_upper()),k)
					bi.select(0)
					bi.connect("item_selected",self,"_set_var",[vars,i,j])
					line.get_node("Args").add_child(bi)
					line.get_node("Args").add_child(si)
				elif typeof(v)==TYPE_STRING:
					if v=="in":
						var li = Label.new()
						li.text = "in"
						line.get_node("Args").add_child(li)
					elif "for" in current_code[i] && j==1:
						var li = Label.new()
						li.text = tr(v.to_upper())
						line.get_node("Args").add_child(li)
					else:
						var bi = OptionButton.new()
						if v in Programs.STATEMENTS:
							for k in range(Programs.STATEMENTS.size()):
								bi.add_item(tr(Programs.STATEMENTS[k].to_upper()),k)
								if Programs.STATEMENTS[k] in v:
									bi.select(k)
							bi.connect("item_selected",self,"_set_statement",[i,j])
						elif v in Programs.TARGETS || "connect" in current_code[i]:
							var vars = Programs.TARGETS+get_vars(i)
							for k in range(vars.size()):
								bi.add_item(tr(vars[k].to_upper()),k)
								if vars[k] in v:
									bi.select(k)
							bi.connect("item_selected",self,"_set_target",[i,j])
						elif v in Programs.SETS:
							for k in range(Programs.SETS.size()):
								bi.add_item(tr(Programs.SETS[k].to_upper()),k)
								if Programs.SETS[k] in v:
									bi.select(k)
							bi.connect("item_selected",self,"_set_set",[i,j])
						else:
							var vars = Programs.VARS+get_vars(i)
							if v in vars:
								for k in range(vars.size()):
									bi.add_item(tr(vars[k].to_upper()),k)
									if vars[k] in v:
										bi.select(k)
								bi.connect("item_selected",self,"_set_var",[vars,i,j])
						line.get_node("Args").add_child(bi)
		line.get_node("ButtonDelete").raise()
		if !"//" in current_code[i] && ("if" in current_code[i] || "elif" in current_code[i] || "else" in current_code[i] || "for" in current_code[i] || "while" in current_code[i]):
			intend += 1
		line.show()
		button.show()
	$Code/Statistics/Label.text = tr("NUM_LINES")+": "+str(prgm.lines)+"\n"+tr("MEMORY")+": "+str(prgm.size)+"\n"+tr("MAX_CPU")+": "+str(prgm.max_cpu)+"\n"+tr("MEAN_CPU")+": "+str(prgm.mean_cpu).pad_decimals(1)+"\n"+tr("COST")+": "+str(prgm.cost)+"\n"
	connect_ui_sounds_recursively($Code)

func _delete_line(ID):
	if "if" in current_code[ID] || "elif" in current_code[ID] || "else" in current_code[ID] || "for" in current_code[ID] || "while" in current_code[ID]:
		var offset = 0
		var end = ID
		for i in range(ID+1,current_code.size()):
			if "end" in current_code[i]:
				offset -= 1
			if "if" in current_code[i] || "elif" in current_code[i] || "else" in current_code[i] || "for" in current_code[i] || "while" in current_code[i]:
				offset += 1
			if offset<0:
				end = i
				break
		if "elif" in current_code[ID] || "else" in current_code[ID]:
			end -= 1
		for i in range(end,ID-1,-1):
			current_code.remove(i)
	elif "end" in current_code[ID]:
		var offset = 0
		var start = ID
		for i in range(ID-1,-1,-1):
			if "end" in current_code[i]:
				offset -= 1
			if "if" in current_code[i] || "elif" in current_code[i] || "else" in current_code[i] || "for" in current_code[i] || "while" in current_code[i]:
				offset += 1
			if offset>0:
				start = i
				break
		for i in range(ID,start-1,-1):
			current_code.remove(i)
	else:
		current_code.remove(ID)
	update_program()

func _add_line(pos):
	new_line_pos = pos
	$Code/PopupMenu.popup(Rect2(get_node("Code/Code/VBoxContainer/Line"+str(pos)).rect_position+$Code/Code.rect_position,get_node("Code/Code/VBoxContainer/Line"+str(pos)).rect_size))

func _add_new_line(ID):
	var line = Programs.known_commands[ID]
	if line=="connect":
		line += " "+Programs.TARGETS[0]
	elif line=="attack" || line=="protect" || line=="sleep":
		line += " 1"
	elif line=="if" || line=="elif" || line=="while":
		line += " _true"
	elif line=="for":
		var offset = 0
		for i in range(new_line_pos):
			if "for" in current_code[i] || "if" in current_code[i] || "elif" in current_code[i] || "else" in current_code[i] || "while" in current_code[i]:
				offset += 1
			if "end" in current_code[i]:
				offset -= 1
		line += " "+Programs.FOR_VARS[offset]+" in "+Programs.SETS[0]
	current_code.insert(new_line_pos,line)
	if "if" in line || "while" in line || "for" in line:
		current_code.insert(new_line_pos+1,"end")
	update_program()

func _set_comment(text,line):
	current_code[line] = "// "+text
	update_program()

func _set_arg(val,line,ID):
	var array = current_code[line].split(" ",false)
	if array.size()<=ID:
		return
	var code = array[0]+" "
	array[ID] = str(val)
	for i in range(1,array.size()):
		code += array[i]+" "
	current_code[line] = code
	update_program()

func _set_set(k,line,ID):
	_set_arg(Programs.SETS[k],line,ID)

func _set_target(k,line,ID):
	_set_arg((Programs.TARGETS+get_vars(line))[k],line,ID)

func _set_var(k,vars,line,ID):
	if k==0:
		_set_arg(1,line,ID)
	else:
		_set_arg(vars[k],line,ID)

func _set_statement(k,line,ID):
	var v = Programs.STATEMENTS[k]
	var array = current_code[line].split(" ",false)
	if array.size()<4 && ("<" in v || ">" in v || "=" in v):
		v = "1 "+v+" 1"
	elif array.size()>2 && !("<" in v || ">" in v || "=" in v):
		current_code[line] = array[0]+" "+v
		update_program()
		return
	_set_arg(v,line,ID)

func get_vars(line):
	var ret = []
	var offset = 0
	var f = {}
	for i in range(line+1):
		if "for" in current_code[i]:
			f[offset] = true
			offset += 1
		if "if" in current_code[i] || "while" in current_code[i]:
			offset += 1
		if "end" in current_code[i]:
			offset -= 1
			if offset<=0:
				f[offset] = false
	for k in f.keys():
		if f[k]:
			ret.push_back(Programs.FOR_VARS[k])
	return ret

func _scan():
	for _i in range(5):
		if Objects.targets.size()>0:
			var target = Objects.targets.keys()[randi()%Objects.targets.size()]
			Objects.remove_opt_target(target)
		else:
			break
	for _i in range(5):
		var ID = Objects.create_group_target(10+log(1.0+Objects.actors.player.rating/10.0))
		if !(ID in targets):
			targets.push_back(ID)
	_show_targets()

func add_log_msg(name,text=name):
	Events.logs.push_back([name,text,OS.get_unix_time()])


func get_save_files():
	var filename : String
	var dir := Directory.new()
	var error := dir.open("user://saves")
	if error!=OK:
		dir.make_dir_recursive("user://saves")
		return
	save_files.clear()
	dir.list_dir_begin(true)
	filename = dir.get_next()
	while filename!="":
		if ".sav" in filename:
			save_files.push_back(filename.replace(".sav",""))
		filename = dir.get_next()
	dir.list_dir_end()

func _save(filename=$Saves/ScrollContainer/VBoxContainer/New/LineEdit.text):
	filename = filename.split(".")[0]
	if filename=="":
		return
	var file := File.new()
	var error := file.open("user://saves/"+filename+".sav",File.WRITE)
	if error!=OK:
		printt("Error",error,"opening file","user://saves/"+filename+".sav")
		return
	
	var visible_tabs := {}
	for c in $Left/ScrollContainer/VBoxContainer.get_children():
		visible_tabs[c.name] = c.visible
	file.store_line(JSON.print({"version":VERSION,"player_name":Objects.actors.player.name,"date":OS.get_datetime()}))
	file.store_line(JSON.print({"contacts":contacts,"targets":targets,"visible_tabs":visible_tabs,"can_scan":can_scan,"new_targets":new_targets}))
	file.store_line(JSON.print({"decks":decks,"current_deck":deck_selected,"building":building,"upgrades":upgrades,"gear":upgraded}))
	file.store_line(JSON.print({"chat_log":chat_log,"chat_read":chat_read,"chat_choice":chat_choice}))
	Events._save(file)
	Objects._save(file)
	Programs._save(file)
	Vars._save(file)
	file.close()
	if $Saves.visible:
		_close(true)

func _load(filename):
	var file := File.new()
	var error := file.open("user://saves/"+filename+".sav",File.READ)
	if error!=OK:
		printt("Error",error,"opening file","user://saves/"+filename+".sav")
		return
	
	var currentline = JSON.parse(file.get_line()).result
	if currentline==null || currentline["version"]!=VERSION:
		print("incompatible version")
		return
	quicksave()
	reset()
	currentline = JSON.parse(file.get_line()).result
	contacts = currentline.contacts
	targets = currentline.targets
	for c in currentline.visible_tabs.keys():
		get_node("Left/ScrollContainer/VBoxContainer/"+c).visible = currentline.visible_tabs[c]
	can_scan = currentline.can_scan
	new_targets = currentline.new_targets
	currentline = JSON.parse(file.get_line()).result
	decks = currentline.decks
	deck_selected = currentline.current_deck
	building = currentline.building
	upgrades = currentline.upgrades
	upgraded = currentline.gear
	currentline = JSON.parse(file.get_line()).result
	chat_log = currentline.chat_log
	chat_read = currentline.chat_read
	chat_choice = currentline.chat_choice
	Events._load(file)
	Objects._load(file)
	Programs._load(file)
	Vars._load(file)
	file.close()
	contact_selected = null
	target_selected = null
	mode = ""
	active = true
	if $Saves.visible:
		_close(true)
	update_main_menu()

func _select_file(ID):
	if mode=="load":
		_load(save_files[ID])
	elif mode=="save":
		_save(save_files[ID])

func quicksave():
	if !active:
		return
	_save('autosave')

func quickload():
	_load('autosave')


func _show_new_game():
	_close(true)
	$Top/HBoxContainer/Title.text = tr("LOGIN")
	$Login.show()
	$Top/HBoxContainer/ButtonClose/Icon.texture = icon_close
	$Login/Input/LineEdit.editable = true
	$Login/Input/ButtonConfirm.disabled = false
	$Login/Input/LineEdit.grab_focus()

func _show_chat():
	_close(true)
	$Top/HBoxContainer/Title.text = tr("CHAT")
	$Chat.show()
	$Top/HBoxContainer/ButtonClose/Icon.texture = icon_close
	$Chat/Panel/Tween.stop_all()
	$Chat/Panel.self_modulate = Color(0,0,0,0)
	for c in $Chat/Panel/ScrollContainer/VBoxContainer.get_children():
		c.queue_free()
	if has_node("Chat/Panel/BG"):
		$Chat/Panel/BG/AnimationPlayer.play("fade_out")
	for c in $Chat/Panel/Portrait.get_children():
		c.get_node("AnimationPlayer").play("fade_out")
	for c in $Chat/ScrollContainer/VBoxContainer.get_children():
		c.hide()
	for c in $Chat/Input/ScrollContainer/HBoxContainer.get_children():
		c.hide()
	for c in contacts:
		var bi
		if !has_node("Chat/Input/ScrollContainer/HBoxContainer/"+c):
			bi = $Chat/ScrollContainer/VBoxContainer/Button0.duplicate()
			bi.name = c
			$Chat/ScrollContainer/VBoxContainer.add_child(bi)
			bi.connect("pressed",self,"_select_contact",[c])
		else:
			bi = get_node("Chat/Input/ScrollContainer/HBoxContainer/"+c)
		bi.show()
		bi.text = tr(Objects.actors[c].name)
		bi.get_node("Panel").modulate = Objects.actors[c].color
		if chat_read.has(c) && chat_log.has(c) && chat_read[c]<chat_log[c].size():
			bi.get_node("Notice/Label").text = str(chat_log[c].size()-chat_read[c])
			bi.get_node("Notice").show()
	$Left/ScrollContainer/VBoxContainer/Button4/Notice.hide()
	Events._on_show_chat()
	connect_ui_sounds_recursively($Chat)

func _show_deck():
	_close(true)
	$Top/HBoxContainer/Title.text = tr("DECK")
	$Deck.show()
	$Top/HBoxContainer/ButtonClose/Icon.texture = icon_close
	
	update_inventory()
	update_decks()

func _show_gear():
	_close(true)
	$Top/HBoxContainer/Title.text = tr("GEAR")
	$Gear.show()
	$Top/HBoxContainer/ButtonClose/Icon.texture = icon_close
	update_upgrades()
	Events._on_show_upgrades()
	

func _show_compile():
	_close(true)
	$Top/HBoxContainer/Title.text = tr("COMPILE")
	$Compile.show()
	$Top/HBoxContainer/ButtonClose/Icon.texture = icon_close
	update_compile()
	Events._on_show_compile()

func _show_code():
	_close(true)
	$Top/HBoxContainer/Title.text = tr("CODE")
	$Code.show()
	$Code/Icon.hide()
	$Top/HBoxContainer/ButtonClose/Icon.texture = icon_close
	_new_program()
	update_code()
	Events._on_show_code()

func _show_targets():
	if game_instance!=null:
		_show_hack()
		return
	_close(true)
	$Top/HBoxContainer/Title.text = tr("WEB")
	$Targets.show()
	$Top/HBoxContainer/ButtonClose/Icon.texture = icon_close
	$Targets/Panel/Tween.stop_all()
	$Targets/Panel.self_modulate = Color(0,0,0,0)
	$Targets/Panel.modulate = Color(1,1,1,0)
	$Left/ScrollContainer/VBoxContainer/Button8/Notice.hide()
	$Left/ScrollContainer/VBoxContainer/Button8/Notice/Label.text = "0"
	new_targets = 0
	for c in $Targets/ScrollContainer/VBoxContainer.get_children():
		c.hide()
	for c in targets:
		var bi
		if !has_node("Targets/Input/ScrollContainer/HBoxContainer/"+c):
			bi = $Targets/ScrollContainer/VBoxContainer/Button0.duplicate()
			$Targets/ScrollContainer/VBoxContainer.add_child(bi)
			bi.connect("pressed",self,"_select_target",[c])
		else:
			bi = get_node("Targets/Input/ScrollContainer/HBoxContainer/"+c)
		bi.show()
		bi.get_node("Label").text = tr(Objects.targets[c].name)
		bi.get_node("Panel").modulate = Objects.targets[c].color
	if can_scan:
		$Targets/ScrollContainer/VBoxContainer/ButtonScan.show()
	connect_ui_sounds_recursively($Targets)

func _show_log():
	_close(true)
	$Top/HBoxContainer/Title.text = tr("LOG")
	$Log/Text/VBoxContainer/HBoxContainer.hide()
	$Log.show()
	$Top/HBoxContainer/ButtonClose/Icon.texture = icon_close
	update_log()

func _show_hack():
	_close(true)
	$Top/HBoxContainer/Title.text = tr("HACK")
	$Hack.show()
	$Hack/Panel.hide()
	$Hack/Result.hide()
	$Background.hide()
	$Hack/Result.hide()
	$Top/HBoxContainer/ButtonClose/Icon.texture = icon_close
	if has_node("/root/Main"):
		if $"/root/Main".time>=0.0:
			$"/root/Main".active = true
			$Hack/Result.hide()
		else:
			$Hack/Result.show()

func _show_load():
	_close(true)
	$Top/HBoxContainer/Title.text = tr("LOAD")
	$Saves.show()
	mode = "load"
	get_save_files()
	for c in $Saves/ScrollContainer/VBoxContainer.get_children():
		c.hide()
	for i in range(save_files.size()):
		var bi
		var error
		var currentline
		var file = File.new()
		if has_node("Saves/ScrollContainer/VBoxContainer/Button"+str(i)):
			bi = get_node("Saves/ScrollContainer/VBoxContainer/Button"+str(i))
		else:
			bi = $Saves/ScrollContainer/VBoxContainer/Button0.duplicate(0)
			bi.connect("pressed",self,"_select_file",[i])
			$Saves/ScrollContainer/VBoxContainer.add_child(bi)
		error = file.open("user://saves/"+save_files[i]+".sav",File.READ)
		if error==OK:
			currentline = JSON.parse(file.get_line()).result
			if currentline.has("player_name"):
				bi.get_node("HBoxContainer/LabelName").text = currentline["player_name"]
			if currentline.has("date"):
				var date = currentline["date"]
				bi.get_node("HBoxContainer/LabelDate").text = str(date["day"]).pad_zeros(2)+"."+str(date["month"]).pad_zeros(2)+"."+str(date["year"])+"  "+str(date["hour"]).pad_zeros(2)+":"+str(date["minute"]).pad_zeros(2)
		bi.get_node("HBoxContainer/LabelFilename").text = save_files[i]+".sav"
		bi.show()
	if $Saves/ScrollContainer/VBoxContainer/Button0.visible:
		$Saves/ScrollContainer/VBoxContainer/Button0.grab_focus()
	connect_ui_sounds_recursively($Saves)

func _show_save():
	_close(true)
	$Top/HBoxContainer/Title.text = tr("SAVE")
	$Saves.show()
	mode = "save"
	get_save_files()
	for c in $Saves/ScrollContainer/VBoxContainer.get_children():
		c.hide()
	for i in range(save_files.size()):
		var bi
		if has_node("Saves/ScrollContainer/VBoxContainer/Button"+str(i)):
			bi = get_node("Saves/ScrollContainer/VBoxContainer/Button"+str(i))
		else:
			bi = $Saves/ScrollContainer/VBoxContainer/Button0.duplicate(0)
			bi.connect("pressed",self,"_select_file",[i])
			$Saves/ScrollContainer/VBoxContainer.add_child(bi)
		bi.get_node("HBoxContainer/LabelFilename").text = save_files[i]+".sav"
		bi.show()
	$Saves/ScrollContainer/VBoxContainer/New.show()
	$Saves/ScrollContainer/VBoxContainer/New/LineEdit.placeholder_text = tr("FILENAME")
	$Saves/ScrollContainer/VBoxContainer/New/LineEdit.text = ""
	$Saves/ScrollContainer/VBoxContainer/New/LineEdit.grab_focus()
	$Saves/ScrollContainer/VBoxContainer/New.raise()
	connect_ui_sounds_recursively($Saves)

func _show_credits():
	_close(true)
	$Top/HBoxContainer/Title.text = tr("CREDITS")
	$Credits.show()

func _show_quit():
	_close(true)
	$Top/HBoxContainer/Title.text = tr("SHUTDOWN")
	$Quit.show()
	$Top/HBoxContainer/ButtonClose/Icon.texture = icon_close


func _close(no_quit=false):
	$Top/HBoxContainer/ButtonClose/Icon.texture = icon_shutdown
	$Top/HBoxContainer/Title.text = VERSION
	$Background.show()
	mode = ""
	
	if $Login.visible:
		$Login.hide()
	elif $Chat.visible:
		$Chat.hide()
		if contact_selected!=null:
			chat_read[contact_selected] = chat_log[contact_selected].size()
			contact_selected = null
	elif $Log.visible:
		$Log.hide()
	elif $Deck.visible:
		$Deck.hide()
		contact_selected = null
	elif $Compile.visible:
		$Compile.hide()
	elif $Gear.visible:
		$Gear.hide()
	elif $Code.visible:
		$Code.hide()
	elif $Targets.visible:
		$Targets.hide()
	elif $Hack.visible:
		if has_node("/root/Main"):
			$"/root/Main".active = false
		$Hack.hide()
	elif $Credits.visible:
		$Credits.hide()
	elif $Saves.visible:
		$Saves.hide()
	elif $Quit.visible:
		$Quit.hide()
	elif !no_quit:
		if !$Quit.visible:
			_show_quit()
		elif active:
			quicksave()
			reset()
		else:
			quicksave()
			get_tree().quit()

func _quit():
	if active:
		quicksave()
		reset()
		Music.play_default()
	else:
		quicksave()
		get_tree().quit()

func _screen_resized():
	yield(get_tree(),"idle_frame")
	$Code/Icon/ScrollContainer/GridContainer.columns = int(($Code/Icon/ScrollContainer/GridContainer.rect_size.x-4)/196)
	if $Deck.visible:
		update_inventory()
		update_deck()
	


func _process(delta):
	var date = OS.get_datetime()
	$Top/HBoxContainer/Date.text = str(date["day"]).pad_zeros(2)+"."+str(date["month"]).pad_zeros(2)+"."+str(date["year"])
	$Top/HBoxContainer/Time.text = str(date["hour"]).pad_zeros(2)+":"+str(date["minute"]).pad_zeros(2)
	
	if active:
		for i in range(building.size()-1,-1,-1):
			building[i]["delay"] -= delta
			if building[i]["delay"]<=0.0:
				call(building[i]["method"],building[i])
				building.remove(i)
				if $Compile.visible:
					update_compile()
				if $Gear.visible:
					update_upgrades()
			else:
				if $Compile.visible:
					get_node("Compile/ScrollContainer/GridContainer/Stack"+str(i)+"/ProgressBar").value = building[i]["time"]-building[i]["delay"]
					get_node("Compile/ScrollContainer/GridContainer/Stack"+str(i)+"/ProgressBar/Label").text = str(building[i]["delay"]).pad_decimals(1)+"s"
				elif $Gear.visible:
					get_node("Gear/ScrollContainer/GridContainer/Stack"+str(i)+"/ProgressBar").value = building[i]["time"]-building[i]["delay"]
					get_node("Gear/ScrollContainer/GridContainer/Stack"+str(i)+"/ProgressBar/Label").text = str(building[i]["delay"]).pad_decimals(1)+"s"

func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("cancel"):
			_close()


func get_data_str(data)->String:
	data = int(data)
	if data>1024*1024:
		return str(data/1024/1024).pad_decimals(1)+"GB"
	elif data>1024:
		return str(data/1024).pad_decimals(1)+"MB"
	else:
		return str(data).pad_decimals(1)+"kB"

func _log_item_selected():
	var type = $Log/ScrollContainer/Tree.get_selected().type
	var ID = $Log/ScrollContainer/Tree.get_selected().ID
	select_log(type,ID)

func update_logo(logo):
	var draw := $ViewportLogo/Draw
	draw.clear()
	if logo.has("ring"):
		draw.ring = logo.ring
	if logo.has("circles"):
		draw.circles = logo.circles
	if logo.has("rays"):
		draw.rays = logo.rays
	if logo.has("poly"):
		draw.poly = logo.poly
	if logo.has("text"):
		draw.get_node("Label").text = logo.text.text
		draw.get_node("Label").add_font_override("font",load("res://fonts/"+logo.text.font))
		draw.get_node("Label").show()
	else:
		draw.get_node("Label").hide()
	draw.update()

func select_log(type,ID):
	var text := $Log/Text/VBoxContainer/Text
	var logo := $Log/Text/VBoxContainer/HBoxContainer/Logo
	var text_right := $Log/Text/VBoxContainer/HBoxContainer/Text
	
	text.clear()
	text_right.clear()
	$Log/Text/VBoxContainer/HBoxContainer.hide()
	if type=="log":
		for array in Events.logs:
			var date = OS.get_datetime_from_unix_time(array[2])
			text.add_text(str(date["day"]).pad_zeros(2)+"."+str(date["month"]).pad_zeros(2)+"."+str(date["year"])+" - "+str(date["hour"]).pad_zeros(2)+":"+str(date["minute"]).pad_zeros(2)+"\n")
			text.add_text("  "+tr(array[1]))
			text.newline()
	elif type=="command_overview":
		text.add_text(tr("KNOWN_COMMANDS")+": "+str(Programs.known_commands.size())+"/"+str(Programs.COMMANDS.size()+Programs.STATEMENTS.size()+Programs.SETS.size()+Programs.TARGETS.size()))
	elif type=="command":
		text.add_text(tr(Programs.known_commands[ID].to_upper()+"_ARGS"))
		text.newline()
		text.add_text(tr(Programs.known_commands[ID].to_upper()+"_DESC"))
	elif type=="person":
		var actor = Objects.actors[ID]
		text.add_text(actor.name)
		text.newline()
		if actor.desc!=null:
			text.add_text(tr(actor.desc))
			text.newline()
		text.newline()
		text.add_text(tr("STRENGTH")+": "+str(actor.strength))
		text.newline()
		text.add_text(tr("RATING")+": "+str(actor.rating))
		text.newline()
		text.add_text(tr("RELATIONS")+": "+str(int(actor.relation)))
		text.newline()
		text.add_text(tr("DATA")+": "+get_data_str(actor.data))
		text.newline()
		text.newline()
		text.add_text(tr("PERSONALITY")+":\n")
		for k in Objects.PERSONALITIES:
			text.add_text(" "+tr(k.to_upper())+": "+str(actor.personality[k])+"\n")
	elif type=="country_overview":
		var pop = Objects.get_total_population()
		var ranks = Objects.get_influence_ranking()
		text_right.add_text(tr("COUNTRIES")+": "+str(Objects.countries.size()))
		text_right.newline()
		text_right.newline()
		text_right.add_text(tr("WORLD_POPULATION")+": "+str(pop/1000.0).pad_decimals(2)+" "+tr("BILLIONS"))
		text_right.newline()
		for c in Objects.countries.values():
			text.push_color(c.color)
			text.add_text(c.name)
			text.push_color(Color(1,1,1))
			text.add_text(": "+str(c.population/1000.0).pad_decimals(2)+" "+tr("BILLIONS")+" ("+str(100.0*c.population/pop).pad_decimals(1)+"%)")
			text.newline()
		text.newline()
		text.add_text(tr("INFLUENCE")+":")
		text.newline()
		for k in Objects.countries.keys():
			var c = Objects.countries[k]
			var rank = -1
			for i in range(ranks.size()):
				if ranks[i].ID==k:
					rank = i
					break
			text.push_color(c.color)
			text.add_text(c.name)
			text.push_color(Color(1,1,1))
			text.add_text(": "+str(c.influence))
			if rank>=0:
				text.add_text(" ("+str(rank+1)+".)")
			text.newline()
		
		logo.hide()
		$Log/Text/VBoxContainer/HBoxContainer.show()
	elif type=="group":
		var group = Objects.groups[ID]
		text_right.push_color(group.color)
		text_right.add_text(group.name)
		text_right.push_color(Color(1,1,1))
		text_right.newline()
		text_right.add_text(" - "+group.form+" - ")
		text.add_text(tr("LOCATION")+": "+tr(group.location))
		text.newline()
		text.add_text(tr("INFLUENCE")+": "+str(group.influence))
		text.newline()
		text.newline()
		text.add_text(tr("RELATION")+": "+str(int(group.relation)))
		text.newline()
		text.add_text(tr("DATA")+": "+str(get_data_str(group.data)))
		text.newline()
		text.newline()
		group.print_desc(text)
		text.newline()
		text.newline()
		text.add_text(str(group.traits))
		text.newline()
		
		update_logo(group.logo)
		logo.texture = $ViewportLogo.get_texture()
		logo.show()
		$Log/Text/VBoxContainer/HBoxContainer.show()
	elif type=="event":
		var event = Objects.events[ID]
		var time = OS.get_datetime_from_unix_time(event.date)
		var date = str(time.day)+"."+str(time.month)+"."+str(time.year)
		text.add_text(tr(event.name))
		text.newline()
		text.add_text(date)
		text.newline()
		text.newline()
		text.add_text(tr("DATA")+": "+str(get_data_str(event.data)))
		text.newline()
		text.newline()
		event.print_desc(text)
		
	

func _log_link(data):
	select_log(data.type,data.ID)
	

func connect_ui_sounds_recursively(node):
	for c in node.get_children():
		if c is BaseButton:
			if !c.is_connected("mouse_entered",$SoundHover,"play"):
				c.connect("mouse_entered",$SoundHover,"play")
			if !c.is_connected("pressed",$SoundHover,"play"):
				c.connect("pressed",$SoundClick,"play")
			
		connect_ui_sounds_recursively(c)

func _ready():
	var credits_text := $Credits/RichTextLabel
	randomize()
	reset()
	Music.play_default()
	
	# connect signals #
	get_tree().connect("screen_resized",self,"_screen_resized")
	$Top/HBoxContainer/ButtonClose.connect("pressed",self,"_close")
	$Left/ScrollContainer/VBoxContainer/Button0.connect("pressed",self,"quickload")
	$Left/ScrollContainer/VBoxContainer/Button1.connect("pressed",self,"_show_new_game")
	$Left/ScrollContainer/VBoxContainer/Button2.connect("pressed",self,"_show_load")
	$Left/ScrollContainer/VBoxContainer/Button3.connect("pressed",self,"_show_save")
	$Left/ScrollContainer/VBoxContainer/Button4.connect("pressed",self,"_show_chat")
	$Left/ScrollContainer/VBoxContainer/Button5.connect("pressed",self,"_show_deck")
	$Left/ScrollContainer/VBoxContainer/Button6.connect("pressed",self,"_show_compile")
	$Left/ScrollContainer/VBoxContainer/Button7.connect("pressed",self,"_show_gear")
	$Left/ScrollContainer/VBoxContainer/Button8.connect("pressed",self,"_show_targets")
	$Left/ScrollContainer/VBoxContainer/Button9.connect("pressed",self,"_show_code")
	$Left/ScrollContainer/VBoxContainer/Button10.connect("pressed",self,"_show_log")
	$Left/ScrollContainer/VBoxContainer/Button11.connect("pressed",self,"_show_credits")
	
	$Login/Input/LineEdit.connect("text_entered",self,"_start_new_game")
	$Login/Input/ButtonConfirm.connect("pressed",self,"_start_new_game")
	$Deck/HBoxContainer/Add.connect("pressed",self,"_add_deck")
	$Deck/HBoxContainer/Deck1.connect("pressed",self,"_select_deck",[0])
	$Targets/Panel/ButtonAttack.connect("pressed",self,"_attack_target")
	$Targets/ScrollContainer/VBoxContainer/ButtonScan.connect("pressed",self,"_scan")
	$Hack/Result/ButtonConfirm.connect("pressed",self,"_confirm_hack_result")
	$Code/ScrollContainer/VBoxContainer/ButtonNew.connect("pressed",self,"_new_program")
	$Code/ScrollContainer/VBoxContainer/Button0.connect("pressed",self,"_load_program",[0])
	$Code/Code/VBoxContainer/Line0/ButtonDelete.connect("pressed",self,"_delete_line",[0])
	$Code/Code/VBoxContainer/Add0.connect("pressed",self,"_add_line",[0])
	$Code/Top/Button0.connect("pressed",self,"_new_program")
	$Code/Top/Button1.connect("pressed",self,"_save_program")
	$Code/Top/Button2.connect("pressed",$Code/Icon,"show")
	$Code/Top/Button3.connect("pressed",self,"_delete_program")
	$Code/Code/VBoxContainer/Name.connect("text_entered",self,"_set_code_name")
	$Code/Icon/HBoxContainer/Button1.connect("pressed",self,"_set_program_icon")
	$Code/Icon/HBoxContainer/Button2.connect("pressed",$Code/Icon,"hide")
	$Code/Icon/ScrollContainer/GridContainer/Button0.connect("pressed",self,"_select_program_icon",[0])
	$Log/Text/VBoxContainer/Text.connect("meta_clicked",self,"_log_link")
	$Saves/ScrollContainer/VBoxContainer/Button0.connect("pressed",self,"_select_file",[0])
	$Saves/ScrollContainer/VBoxContainer/New/LineEdit.connect("text_entered",self,"_save")
	$Saves/ScrollContainer/VBoxContainer/New/ButtonConfirm.connect("pressed",self,"_save")
	$Quit/ButtonClose.connect("pressed",self,"_quit")
	
	connect_ui_sounds_recursively(self)
	
	for i in range(PROGRAM_ICONS.size()):
		var bi
		if has_node("Code/Icon/ScrollContainer/GridContainer/Button"+str(i)):
			bi = get_node("Code/Icon/ScrollContainer/GridContainer/Button"+str(i))
		else:
			bi = $Code/Icon/ScrollContainer/GridContainer/Button0.duplicate(0)
			bi.name = "Button"+str(i)
			$Code/Icon/ScrollContainer/GridContainer.add_child(bi)
			bi.connect("pressed",self,"_select_program_icon",[i])
		bi.get_node("TextureRect").texture = load("res://images/cards/"+PROGRAM_ICONS[i]+".png")
	
	credits_text.clear()
	credits_text.add_text(tr("MADE_WITH_GODOT")+" (")
	credits_text.append_bbcode("[url=https://godotengine.org]godotengine.org[/url]")
	credits_text.add_text(")\n\n")
	credits_text.append_bbcode("[b]"+tr("PROGRAMMING")+":[/b]\n")
	credits_text.add_text(" - Viktor Hahn\n\n")
	credits_text.append_bbcode("[b]"+tr("GRAPHICS")+":[/b]\n")
	credits_text.add_text(" - Viktor Hahn\n")
	credits_text.add_text(" - Lorc (")
	credits_text.append_bbcode("[url=https://game-icons.net/]game-icons.net[/url]")
	credits_text.add_text(")\n\n")
	credits_text.append_bbcode("[b]"+tr("MUSIC")+":[/b]\n")
	credits_text.add_text(" - Of Far Different Nature (")
	credits_text.append_bbcode("[url=https://fardifferent.carrd.co]fardifferent.carrd.co[/url]")
	credits_text.add_text(")\n")
	credits_text.add_text(" - maxstack (")
	credits_text.append_bbcode("[url=https://opengameart.org/content/freelance]opengameart.org[/url]")
	credits_text.add_text(")\n")
	credits_text.add_text(" - tricksntraps (")
	credits_text.append_bbcode("[url=https://opengameart.org/content/t-t-free-cyberpunk-pack]opengameart.org[/url]")
	credits_text.add_text(")\n\n")
	credits_text.append_bbcode("[b]"+tr("SOUNDS")+":[/b]\n")
	credits_text.add_text(" - LittleRobotSoundFactory\n")
	credits_text.add_text(" - soneproject\n")
	credits_text.add_text(" - PatrickLieberkind\n")
	credits_text.add_text(" - suonho\n")
	credits_text.add_text(" - pcruzn\n")
	credits_text.add_text(" - stewdio2003\n")
	credits_text.add_text(" - soundmatch24\n")
	credits_text.add_text(" - noirenex\n")
	credits_text.add_text(" - aust_paul\n")
	credits_text.add_text(" - cabled_mess\n")
	credits_text.add_text(" - deleted_user_1941307\n\n")
	credits_text.append_bbcode("[b]"+tr("FONTS")+":[/b]\n")
	credits_text.add_text(" - Kenney Vleugels (")
	credits_text.append_bbcode("[url=http://www.kenney.nl]www.kenney.nl[/url]")
	credits_text.add_text(")\n")
	credits_text.add_text(" - Jonas Hecksher\n\n")
	credits_text.connect("meta_clicked",Object(OS),"shell_open")
	
	OS.window_maximized = true

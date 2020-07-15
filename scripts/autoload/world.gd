extends Node

const COUNTRIES = [
	"ASIA","EAST_ASIA",
	"EUROPE","WESTERN_EUROPE","CENTRAL_EUROPE",
	"AFRICA","CENTRAL_AFRICA",
	"NORTH_AMERICA","SOUTH_AMERICA",
	"AUSTRALIA","ANTARCTICA"
]
const NAMES_COMPANY_PREFIX = [
	"FEMTO","MEGA","MACRO","ORANGE","GALACTIC","GLOBAL","CYBER","CRYPTO","MECH","MED","TRANSCENDENCE","FIN","NEO"
]
const NAMES_COMPANY_SUFFIX = [
	"BANK","CORP","CORPORATION","INC","SYNDICATE","SYS","SYSTEMS","SOFT","TECH","GROUP","COMPANY","MANUFACTORY","WORKS"
]
const NAMES_ORDER_PREFIX = [
	"ABSOLUTE","PURE","HOLY","TRUE","IRON","BLOOD"
]
const NAMES_ORDER_SUFFIX = [
	"ORDER","CONFRATERNITY","BROTHERHOOD","CULT","SECT","CHURCH"
]
const NAMES_ORDER_OBJECTIVE = [
	"PURITY","TRANSCENDENCE","SINGULARITY","NATURE","CRYPTOGRAPHY"
]
const NAMES_NGO_PREFIX = [
	"HUMAN_RIGHTS","AI_RIGHTS","HEALTH","CHARITY","ANTI_CORRUPTION","SINGULARITY","NATURE","CYBER"
]
const NAMES_NGO_SUFFIX = [
	"ORGANIZATION","FRONTIER","AID","GROUP","FOUNDATION"
]
const NAMES_GOV_PREFIX = [
	"CYBER","DEMOCRATIC","GREAT","SUPPLY"
]
const NAMES_GOV_SUFFIX = [
	"POLICE","SPECIAL_FORCES","PARLIAMENT","MILITARY","ADMINISTRATION","COURT"
]
const NAMES_TERROR_PREFIX = [
	"FREEDOM","LIBERATION","IRON","BLOOD","CYBER","ASSASSINATION","CHAOS"
]
const NAMES_TERROR_SUFFIX = [
	"FRONTIER","GROUP","RESISTANCE","TERRORISTS"
]
const NAMES_TERROR_OBJECTIVE = [
	"FREEDOM","JUSTICE","GOD","BLOODSHED","CHAOS"
]
const GROUP_TRAITS = {
	"company":["evil","production","services","finance","digital"],
	"order":["altruistic","evil","religous","oppressive"],
	"ngo":["altruistic","religous","freedom","digital","cybernetic"],
	"terrorists":["ai_controled","evil","religious","freedom","oppressive"],
	"government":["ai_controled","cybernetic","corrupt","oppressive"]
}
const GROUP_GENERAL_DEPARTMENTS = [
	"ADMINISTRATION","HEADQUARTERS","MANAGEMENT","RESEARCH","FINANCES",
	"SERVER","ARCHIVE","IT_SYSTEMS","DATA_STORAGE","SERVER_ARCHITECTURE",
	"MAIL_SERVERS"
]
const GROUP_DEPARTMENTS = {
	"+production":["PRODUCTION"],
	"+finance":["FINANCES"],
	"+services":["HOTLINE"],
	"+religious":["CURCH"],
	"+ai_controled":["AI_HIVE"],
	
	"+evil +production":["DEFENCE","ARMORY"],
	"+finance +services":["FINANCIAL_SERVICES"],
	"+finance +digital":["ONLINE_BANKING"],
	"+services +digital":["DIGITAL_TRANSFORMATIONS"],
	"+evil +religious":["RE_EDUCATION_CAMP"],
	"+digital +freedom":["CYBER_RIGHTS"],
	"+cybernetic +altruistic":["CYBER_SECURITY"],
	"+ai_controled +freedom":["AI_FRONTIER","AI_FREEDOM_FIGHTERS"],
	"+cybernetic +oppressive":["CYBER_CONTROL","CYBER_OPPRESSION"],
	"+cyber +digital":["CYBER_DEPARTMENT"],
	
	"+justice":["LEAGUE"],
}
const GROUP_FILES = {
	"":[["secret","top_secret","sensitive","data","readme","classified","staff"]],
	
	"+company":[["finances","marketing","products","new_employees"],
		[["expansion","restructuring","marketing","research"],["plan","strategy"]]],
	"+order":[["finances","followers","believers","heretics","traitors","members","new_members"]],
	"+ngo":[["donations","finances","reports","issues","contacts"],
		[["human_rights","animal_rights","climate_change","finance","donation"],["plan","strategy","report","documentation","issues"]]],
	"+terrorists":[["new_members","members","traitors","locations","targets","destinations","hit_list"],
		[["expansion","assault","target","assassination"],["plan","strategy","list"]]],
	"+government":[["bureaucracy","new_forms","old_forms"],
		[["new","bureaucracy","administration","IT","anti-corruption","power_plant"],["form","servers","plans","report"]]],
	"+military":[["military","new_recruits","recruits","materials","equipment"],
		[["new","disabled","deployed"],["soldiers","recruits","equipment","weapons","vehicles"]],
		[["assault","attack","combat","defence"],["plan","strategy","considerations","report"]]],
	
	"+evil":[[["","how_to","plan"],["kill","destroy","exterminate","kidnap","corrupt"],["all_humans","kitties","society","traitors"]]],
	
}
const FILE_ENDINGS = ["dat","txt","doc","odt","pdf","eps","xml","html","php","exe","x86","png","jpg","gif","wav","ogg","mp3","mp4","webm"]
const DIRECTORY_NAMES = ["desc","bin","trash","documents","images","secret","restricted","classified",".local",".local/share","html","public_html"]
const PERSONALITIES = [
	"curiosity",
	"fear",
	"charisma",
	"focus",
	"cunning"
]

#var objects := {}
var actors := {}
var groups := {}
var countries := {}
var events := []
var targets := {}


class InfluenceSorter:
	static func sort(a, b):
		return a.influence>b.influence

class PopulationSorter:
	static func sort(a, b):
		return a.population>b.population

class DateSorter:
	static func sort(a, b):
		return a.date>b.date


class Obj:
# warning-ignore:unused_class_variable
	var ID := ""
# warning-ignore:unused_class_variable
	var owned := []
# warning-ignore:unused_class_variable
	var name : String
# warning-ignore:unused_class_variable
	var desc
# warning-ignore:unused_class_variable
	var relation : int
	

class Actor extends Obj:
	# NPCs, player character, etc.
	var color : Color
	var portrait : String
	var bg : String
	var strength : float
	var rating : float
	var cpu : int
	var memory : int
	var time_limit : float
	var programs : Dictionary
	var credits : float
	var data : int
	var personality : Dictionary
	
	func _init(_name,_color,_portrait,_bg,_cpu,_memory,_time_limit,_programs,_credits,_rating,_data,_personality={},_relation=0,_ID=null):
		if _ID==null:
			var num = 0
			ID = name.to_lower().replace(" ","_")
			while Objects.actors.has(ID+str(num)):
				num += 1
			ID = ID+str(num)
		else:
			ID = _ID
		name = _name
		color = _color
		portrait = _portrait
		bg = _bg
		cpu = _cpu
		memory = _memory
		time_limit = _time_limit
		programs = _programs
		credits = _credits
		rating = _rating
		data = _data
		personality = _personality
		for p in PERSONALITIES:
			if !personality.has(p):
				personality[p] = 0
		relation = _relation
		strength = 0.0
		
	
	func to_dict():
		var dict = {"type":"actor","name":name,"color":color,"portrait":portrait,"bg":bg,"cpu":cpu,"memory":memory,"time_limit":time_limit,"programs":programs,"credits":credits,"rating":rating,"data":data,"personality":personality,"relation":relation}
		return dict

class Server extends Obj:
	# Target that can be attacked.
	var color : Color
	var layout : String
	var layout_params : Array
	var ai : String
	var programs : Dictionary
	var cpu : int
	var credits : float
	var prestige : float
	var method_on_win
	var group
	var music_overwrite
	var optional := false
	
	func _init(_name,_group,_desc,_color,_layout,_layout_params,_programs,_cpu,_ai,_credits,_prestige,_method_on_win=null,_music_overwrite=null):
		name = _name
		group = _group
		desc = _desc
		color = _color
		layout = _layout
		layout_params = _layout_params
		ai = _ai
		programs = _programs
		cpu = _cpu
		credits = _credits
		prestige = _prestige
		method_on_win = _method_on_win
		music_overwrite = _music_overwrite
	
	func to_dict():
		var dict = {"type":"server","name":name,"group":group,"desc":desc,"color":color,"layout":layout,"layout_params":layout_params,"ai":ai,"programs":programs,"cpu":cpu,"credits":credits,"prestige":prestige,"method_on_win":method_on_win,"music_overwrite":music_overwrite}
		return dict

class Group extends Obj:
	# Companies, organizations, etc. that provide targets aquired via scans and are shown in the log page.
	var form : String
	var color : Color
	var color_alt : Color
	var logo : Dictionary
	var location : String
	var influence : float
	var traits : Array
	var data : int
	var departments : Array
	
	func _init(_name,_desc,_form,_departments,_color,_color_alt,_logo,_location,_influence,_traits,_data):
		name = _name
		form = _form
		departments = _departments
		ID = name.to_lower().replace(" ","_")
		desc = _desc
		color = _color
		color_alt = _color_alt
		logo = _logo
		location = _location
		influence = _influence
		traits = _traits
		data = _data
		
	
	func print_desc(node):
		# Generate a description for the log page.
		for d in desc:
			if desc.has("security") && data<desc.security:
				if desc.security>1024*1024:
					node.add_text(tr("TOP_SECRET"))
				else:
					node.add_text(tr("CONFIDENTIAL"))
			else:
				var text = tr(d.text).replace("<group>",name)
				text[0] = text[0].to_upper()
				Objects.insert_links(node,text,d)
			node.newline()
			node.newline()
	
	func to_dict():
		var dict = {"type":"group","name":name,"form":form,"desc":desc,"color":color,"color_alt":color_alt,"logo":logo,"location":location,"influence":influence,"traits":traits,"data":data,"departments":departments}
		return dict

class Country extends Obj:
	# Used to handle countries shown in the log page.
	var plural := false
	var acronym := ""
	var color : Color
	var traits : Array
	var population : int
	var influence : int
	var development : int
	var data : int
	var relations := {}
	
	func _init(_name,_desc,_plural,_color,_population,_influence,_development,_traits,_data,_relation=0,_relations=null):
		name = _name
		ID = name.to_lower().replace(" ","_")
		desc = _desc
		plural = _plural
		color = _color
		population = _population
		influence = _influence
		development = _development
		traits = _traits
		data = _data
		for s in name.split(" ",false):
			if s.length()>0 && s[0]==s[0].to_upper():
				acronym += s[0]
		if _relations!=null:
			relations = _relations
		relation = _relation
		
	
	func print_desc(node):
		# Generate a description for the log page.
		var num_descs := 0
		for d in desc:
			if desc.has("security") && data<desc.security:
				if desc.security>1024*1024:
					node.add_text(tr("TOP_SECRET"))
				else:
					node.add_text(tr("CONFIDENTIAL"))
			else:
				var text = tr(d.text).replace("<name>",name).replace("<acronym>",acronym).replace("<is/are>",[tr("IS"),tr("ARE")][int(plural)]).replace("<they/it>",[tr("THEY"),tr("IT")][int(plural)]).replace("<was/were>",[tr("WAS"),tr("WERE")][int(plural)])
				if num_descs>0:
					text = text.replace("<country>",tr("THEY"))
				else:
					text = text.replace("<country>",tr("THE")+" "+name)
				text[0] = text[0].to_upper()
				Objects.insert_links(node,text,d)
			node.newline()
			node.newline()
	
	func to_dict():
		var dict = {"type":"country","name":name,"desc":desc,"plural":plural,"color":color,"population":population,"influence":influence,"development":development,"traits":traits,"data":data,"relation":relation,"relations":relations}
		return dict

class Event extends Obj:
	# Used to handle events shown in the log page.
	var date : int
	var data : int
	
	func _init(_name,_desc,_date,_data):
		name = _name
		desc = _desc
		date = _date
		data = _data
		
	
	func print_desc(node):
		# Generate a description for the log page.
		for d in desc:
			if desc.has("security") && data<desc.security:
				if desc.security>1024*1024:
					node.add_text(tr("TOP_SECRET"))
				else:
					node.add_text(tr("CONFIDENTIAL"))
			else:
				var time = OS.get_datetime_from_unix_time(date)
				var date_str = str(time.day)+"."+str(time.month)+"."+str(time.year)
				var text = tr(d.text).replace("<name>",name).replace("<date>",date_str)
				Objects.insert_links(node,text,d)
			node.newline()
			node.newline()
	
	func to_dict():
		var dict = {"type":"event","name":name,"desc":desc,"date":date}
		return dict

func insert_links(node,text,desc):
	# Add links to the log text.
	var array = text.split(" ")
	for t in array:
		if desc.has("event") && "<event>" in t:
			var event = Objects.events[desc.event]
			node.push_meta({"type":"event","ID":desc.event})
			node.add_text(tr(event.name))
			node.pop()
			node.add_text(" ")
		elif desc.has("actor") && "<actor>" in t:
			var actor = Objects.actors[desc.actor]
			node.push_meta({"type":"person","ID":desc.actor})
			node.add_text(tr(actor.name))
			node.pop()
			node.add_text(" ")
		elif desc.has("country") && "<country>" in t:
			var country = Objects.countries[desc.country]
			node.push_meta({"type":"country","ID":desc.country})
			node.add_text(tr(country.name))
			node.pop()
			node.add_text(" ")
		elif desc.has("enemy_country") && "<enemy_country>" in t:
			var country = Objects.countries[desc.enemy_country]
			node.push_meta({"type":"country","ID":desc.enemy_country})
			node.add_text(tr(country.name))
			node.pop()
			node.add_text(" ")
		else:
			node.add_text(t+" ")

func _save(file):
	var acts := {}
	var tg := {}
	var grp := {}
	var evt := []
	evt.resize(events.size())
	for ID in targets.keys():
		tg[ID] = targets[ID].to_dict()
	for ID in actors.keys():
		acts[ID] = actors[ID].to_dict()
	for ID in groups.keys():
		grp[ID] = groups[ID].to_dict()
	for i in range(events.size()):
		evt[i] = events[i].to_dict()
	file.store_line(JSON.print(tg))
	file.store_line(JSON.print(acts))
	file.store_line(JSON.print(grp))
	file.store_line(JSON.print(evt))

func _load(file):
	var currentline = JSON.parse(file.get_line()).result
	targets.clear()
	for ID in currentline.keys():
		var obj
		var dict = currentline[ID]
		# work around because colors can't be saved/loaded properly in JSON format
		var array = dict["color"].split(",")
		var color = Color(array[0],array[1],array[2],array[3])
		if !dict.has("music_overwrite"):
			dict.music_overwrite = null
		obj = Server.new(dict.name,dict.group,dict.desc,color,dict.layout,dict.layout_params,dict.programs,dict.cpu,dict.ai,dict.credits,dict.prestige,dict.method_on_win,dict.music_overwrite)
		targets[ID] = obj
	currentline = JSON.parse(file.get_line()).result
	actors.clear()
	for ID in currentline.keys():
		var obj
		var dict = currentline[ID]
		# work around because colors can't be saved/loaded properly in JSON format
		var array = dict["color"].split(",")
		var color = Color(array[0],array[1],array[2],array[3])
		obj = Actor.new(dict.name,color,dict.portrait,dict.bg,dict.cpu,dict.memory,dict.time_limit,dict.programs,dict.credits,dict.rating,dict.data,dict.personality,dict.relation,ID)
		actors[ID] = obj
	currentline = JSON.parse(file.get_line()).result
	groups.clear()
	for ID in currentline.keys():
		var obj
		var dict = currentline[ID]
		# even more work arounds
		var array1 = dict.color.split(",")
		var array2 = dict.color.split(",")
		var color := Color(array1[0],array1[1],array1[2],array1[3])
		var color_alt := Color(array2[0],array2[1],array2[2],array2[3])
		var logo = dict.logo
		if logo.has("text"):
			var array = logo.text.color.split(",")
			logo.text.color = Color(array[0],array[1],array[2])
		if logo.has("ring"):
			var array = logo.ring.color.split(",")
			logo.ring.color = Color(array[0],array[1],array[2])
		if logo.has("circles"):
			for i in range(logo.circles.size()):
				var array = logo.circles[i].color.split(",")
				logo.circles[i].color = Color(array[0],array[1],array[2])
				array = logo.circles[i].pos.split(",")
				logo.circles[i].pos = Vector2(array[0],array[1])
		if logo.has("rays"):
			var array = logo.rays.color.split(",")
			logo.rays.color = Color(array[0],array[1],array[2])
		if logo.has("poly"):
			for j in range(logo.poly.size()):
				for i in range(logo.poly[j].colors.size()):
					var array = logo.poly[j].colors[i].split(",")
					logo.poly[j].colors[i] = Color(array[0],array[1],array[2])
					array = logo.poly[j].points[i].split(",")
					logo.poly[j].points[i] = Vector2(array[0],array[1])
		obj = Group.new(dict.name,dict.desc,dict.form,dict.departments,color,color_alt,logo,dict.location,dict.influence,dict.traits,dict.data)
		groups[ID] = obj
	currentline = JSON.parse(file.get_line()).result
	events.resize(currentline.size())
	for i in range(currentline.size()):
		var dict = currentline[i]
		var obj = Event.new(dict.name,dict.desc,dict.date,dict.data)
		events[i] = obj


func trigger_on_win(victory):
	for object in targets.values():
		if object is Server && object.method_on_win!=null && Events.has_method(object.method_on_win):
			Events.call(object.method_on_win,victory)

func get_total_node_count(type,params):
	if type=="radial":
		return params[0]+params[1]+params[2]
	elif type=="layered":
		return params[2]
	elif type=="radial_layer":
		return params[0]+params[1]+params[2]
	return 0

func add_target(ID,name,group,desc,color,layout,layout_params,programs,cpu,ai,credits,prestige,method_on_win=null,music_overwrite=null) -> Server:
	# Add a new target to the target list.
	var new_target := Server.new(name,group,desc,color,layout,layout_params,programs,cpu,ai,credits,prestige,method_on_win,music_overwrite)
	targets[ID] = new_target
	$"/root/Menu".targets.push_front(ID)
	$"/root/Menu".new_targets += 1
	$"/root/Menu".update_main_menu()
	return new_target

func remove_target(ID):
	# Remove target from the target list.
	targets.erase(ID)
	$"/root/Menu".targets.erase(ID)
	if $"/root/Menu/Targets".visible:
		$"/root/Menu"._show_targets()

func add_opt_target(ID,name,group,desc,color,layout,layout_params,programs,cpu,ai,credits,prestige,method_on_win=null):
	# Add an optional target to the target list (cleared if scan is used).
	var new_target := Server.new(name,group,desc,color,layout,layout_params,programs,cpu,ai,credits,prestige,method_on_win)
	new_target.optional = true
	targets[ID] = new_target

func remove_opt_target(ID):
	# Remove optional target, check if it is optional first.
	if targets.has(ID) && !targets[ID].optional:
		return
	targets.erase(ID)
	$"/root/Menu".targets.erase(ID)
	if $"/root/Menu/Targets".visible:
		$"/root/Menu"._show_targets()


func get_total_population():
	var pop = 0
	for c in Objects.countries.values():
		pop += c.population
	return pop

func get_influence_ranking():
	var ranks = []
	for c in countries.keys():
		ranks.push_back({"ID":c,"influence":countries[c].influence})
	ranks.sort_custom(InfluenceSorter,"sort")
	return ranks


func create_group_target(strength):
	# Create a new target belonging to a group.
	# Set strength and loadout.
	var ID : String
	var name : String
	var group
	var action_strength : int
	var desc := ""
	var color : Color
	var memory := 0
	var str_eff = sqrt(strength)
	var programs := {
		"pulse":int(rand_range(0.4,1.25)*str_eff+2),
		"wave":int(rand_range(0.2,0.75)*max(str_eff-2,0.0)),
		"anti_virus":int(rand_range(0.25,1.0)*max(str_eff-1,0)),
		"agent":int(rand_range(0.125,0.5)*max(str_eff-5,0.0))
	}
	var cpu := int(rand_range(1.2,1.4)*strength+rand_range(0.5,3.0))
	var credits := int(rand_range(80,100)*strength+rand_range(100,300))
	var prestige := int(rand_range(3.0,3.5)*sqrt(strength))
	var params := [5,4,max(int(rand_range(10.0,16.0)+strength*rand_range(0.1,0.2)),1),max(int(sqrt(strength)*rand_range(0.25,0.6)+rand_range(0.0,0.75)),1)]
	var best_match := 999
	
	for k in groups.keys():
		var score = abs(groups[k].influence*rand_range(0.75,1.25)+rand_range(-5.0,5.0)-strength)
		if score<best_match:
			best_match = score
			group = k
	if group==null:
		group = groups.keys()[randi()%groups.size()]
	color = groups[group].color.blend(Color(rand_range(0.0,1.5),rand_range(0.0,0.5),rand_range(0.0,0.25)))
	name = groups[group].name+" "+tr(groups[group].departments[randi()%+groups[group].departments.size()])
	
	ID = name.to_lower().replace(" ","_")
	action_strength = programs["pulse"]+1.2*programs["wave"]+0.75*programs["anti_virus"]
	programs["fire_wall"] = int(rand_range(0.25,0.75)*(strength-action_strength))
	action_strength += 1.5*programs["fire_wall"]
	if cpu>25:
		programs["worm"] = max(int(1.3*strength-action_strength-rand_range(0.0,2.5)),0)
	if cpu>20:
		programs["agent"] = max(int(1.2*strength-action_strength-rand_range(0.0,1.5)),0)
	if cpu>15:
		programs["phalanx"] = max(int(1.1*strength-action_strength),0)
	for type in programs.keys():
		var prog = Programs.Program.new(Programs.programs[type])
		memory += prog.size*programs[type]
	desc += tr("NODES")+": "+str(get_total_node_count("radial_layer",params))+"\n"+tr("CPU")+": "+str(cpu)+"\n"+tr("MEMORY")+": "+str(memory)
	
	add_opt_target(ID,name,group,desc,color,"radial_layer",params,programs,cpu,"ai_random",credits,prestige,"_remove_opt_target")
	return ID


func create_event(name,date,_traits=[],_type=null,_actor=null,_target=null,data=int(rand_range(8,128))):
	var desc := []
	var event
	
	if typeof(date)==TYPE_ARRAY:
		date = int(rand_range(date[0],date[1]))
	
	event = Event.new(name,desc,date,data)
	return event

func event_get_actor(_desc,ID=null,_country=null,target=null):
	if ID==null:
		if target!=null:
			ID = target.ID
	return ID

func create_groups():
	for _i in range(8):
		create_group("company",COUNTRIES[randi()%COUNTRIES.size()],100.0)
	for _i in range(4):
		create_group("ngo",COUNTRIES[randi()%COUNTRIES.size()],50.0)
	for _i in range(3):
		create_group("order",COUNTRIES[randi()%COUNTRIES.size()],25.0)
	for _i in range(4):
		create_group("military",COUNTRIES[randi()%COUNTRIES.size()],50.0)
	for _i in range(4):
		create_group("government",COUNTRIES[randi()%COUNTRIES.size()],100.0)
	for _i in range(3):
		create_group("terrorists",COUNTRIES[randi()%COUNTRIES.size()],25.0)

func create_group(type,country,infl):
	# Create a new group in a certain country.
	var ID
	var name : String
	var desc := []
	var departments := []
	var color_alt : Color
	var color := Color(rand_range(0.0,1.0),rand_range(0.0,1.0),rand_range(0.0,1.0))
	var influence := int(infl/10.0+rand_range(20.0,50.0))
	var traits := []
	var data := 0
	var logo := {}
	var rndc := randf()
	
	while ID==null || groups.has(ID):
		if type=="government":
			var rnd = randf()
			if rnd<0.4:
				name = tr(NAMES_GOV_PREFIX[randi()%NAMES_GOV_PREFIX.size()])+" "+tr(NAMES_GOV_SUFFIX[randi()%NAMES_GOV_SUFFIX.size()])
			elif rnd<0.8:
				name = tr(NAMES_GOV_SUFFIX[randi()%NAMES_GOV_SUFFIX.size()])+" "+tr("OF")+" "+tr(country)
			else:
				name = tr(NAMES_GOV_PREFIX[randi()%NAMES_GOV_PREFIX.size()])+" "+tr(NAMES_GOV_SUFFIX[randi()%NAMES_GOV_SUFFIX.size()])+" "+tr("OF")+" "+tr(country)
			ID = name.to_lower().replace(" ","_")
			data = int(rand_range(64,768))
			traits = ["government"]
		elif type=="military":
			if randf()<0.5:
				name = tr(NAMES_GOV_PREFIX[randi()%NAMES_GOV_PREFIX.size()])+" "+tr("MILITARY")
			else:
				name = tr("MILITARY")+" "+tr("OF")+" "+tr(country)
			ID = name.to_lower().replace(" ","_")
			data = int(rand_range(64,768))
			traits = ["government"]
		elif type=="company":
			if randf()<0.85:
				name = tr(NAMES_COMPANY_PREFIX[randi()%NAMES_COMPANY_PREFIX.size()])+" "+tr(NAMES_COMPANY_SUFFIX[randi()%NAMES_COMPANY_SUFFIX.size()])
			else:
				name = tr(NAMES_COMPANY_SUFFIX[randi()%NAMES_COMPANY_SUFFIX.size()])+" "+tr("OF")+" "+tr(country)
			ID = name.to_lower().replace(" ","_")
			data = int(rand_range(64,768))
			traits = ["company"]
		elif type=="ngo":
			name = tr(NAMES_NGO_PREFIX[randi()%NAMES_NGO_PREFIX.size()])+" "+tr(NAMES_NGO_SUFFIX[randi()%NAMES_NGO_SUFFIX.size()])
			ID = name.to_lower().replace(" ","_")
			data = int(rand_range(64,768))
			traits = ["ngo"]
		elif type=="order":
			var rnd = randf()
			if rnd<0.4:
				name = tr(NAMES_ORDER_PREFIX[randi()%NAMES_ORDER_PREFIX.size()])+" "+tr(NAMES_ORDER_SUFFIX[randi()%NAMES_ORDER_SUFFIX.size()])
			elif rnd<0.7:
				name = tr(NAMES_ORDER_SUFFIX[randi()%NAMES_ORDER_SUFFIX.size()])+" "+tr("OF")+" "+tr(NAMES_ORDER_OBJECTIVE[randi()%NAMES_ORDER_OBJECTIVE.size()])
			else:
				name = tr(NAMES_ORDER_SUFFIX[randi()%NAMES_ORDER_SUFFIX.size()])+" "+tr("OF")+" "+tr(country)
			ID = name.to_lower().replace(" ","_")
			data = int(rand_range(64,768))
			traits = ["order"]
		elif type=="terrorists":
			var rnd = randf()
			if rnd<0.45:
				name = tr(NAMES_TERROR_PREFIX[randi()%NAMES_TERROR_PREFIX.size()])+" "+tr(NAMES_TERROR_SUFFIX[randi()%NAMES_TERROR_SUFFIX.size()])
			elif rnd<0.8:
				name = tr(NAMES_TERROR_SUFFIX[randi()%NAMES_TERROR_SUFFIX.size()])+" "+tr("OF")+" "+tr(NAMES_TERROR_OBJECTIVE[randi()%NAMES_TERROR_OBJECTIVE.size()])
			else:
				name = tr(NAMES_TERROR_SUFFIX[randi()%NAMES_TERROR_SUFFIX.size()])+" "+tr("OF")+" "+tr(country)
			ID = name.to_lower().replace(" ","_")
			data = int(rand_range(64,768))
			traits = ["terrorists"]
	
	for t in name.split(" ",false):
		if t==tr("OF"):
			continue
		t = t.to_lower()
		if !(t in traits):
			traits.push_back(t)
	if GROUP_TRAITS.has(type):
		for _i in range(1+randi()%2):
			var t = GROUP_TRAITS[type][randi()%GROUP_TRAITS[type].size()]
			if !(t in traits):
				traits.push_back(t)
	
	for d in GROUP_DEPARTMENTS.keys():
		var has := []
		var has_not := []
		var qualified = true
		for t in d.split(" ",false):
			if "+" in t:
				has.push_back(t.replace("+",""))
			elif "-" in t:
				has_not.push_back(t.replace("-",""))
		for tag in has:
			if !(tag in traits):
				qualified = false
				break
		for tag in has_not:
			if tag in traits:
				qualified = false
				break
		if qualified:
			departments += GROUP_DEPARTMENTS[d]
			if departments.size()>5+randi()%4:
				break
	for _i in range(max(6+randi()%4-departments.size(),0)):
		departments.push_back(GROUP_GENERAL_DEPARTMENTS[randi()%GROUP_GENERAL_DEPARTMENTS.size()])
	
	# colors
	if rndc<0.15:
		color_alt = color.contrasted()
	elif rndc<0.35:
		color_alt = color.blend(Color(0.0,0.0,0.0))
	elif rndc<0.55:
		color_alt = color.blend(Color(1.0,1.0,1.0))
	elif rndc<0.65:
		color_alt = color.inverted()
	elif rndc<0.75:
		color_alt = Color(0.0,0.0,0.0)
	elif rndc<0.85:
		color_alt = Color(1.0,1.0,1.0)
	else:
		color_alt = Color(rand_range(0.0,1.0),rand_range(0.0,1.0),rand_range(0.0,1.0))
	
	# logo
	var num_circles := (max((randi()%6)-2,0))*(randi()%2)
	var num_rays := max((randi()%12)-6,0)*(randi()%2)
	var num_poly := (max((randi()%8)-2,0))*(randi()%2)
	if randf()<0.5 || (num_circles==0 && num_rays==0 && num_poly==0):
		logo.ring = {"poly":3+randi()%5,"width":2+randi()%14,"color":get_random_color(color,color_alt)}
		if randf()<0.2:
			logo.ring.poly = 64
	if randf()<0.5 || (num_circles==0 && num_rays==0 && num_poly==0):
		var acr := ""
		var array := name.split(" ",false)
		if randf()<0.2:
			for i in range(array.size()):
				acr += array[i][0].to_upper()+"."
		elif randf()<0.2:
			for i in range(array.size()):
				acr += array[i][0].to_lower()
		else:
			for i in range(array.size()):
				acr += array[i][0].to_upper()
		logo.text = {"text":acr,"font":"logo_font_"+str(randi()%3+1).pad_zeros(2)+".tres","color":get_random_color(color,color_alt)}
	
	if num_circles>0:
		logo.circles = []
		for _i in range(num_circles):
			logo.circles.push_back({"pos":Vector2(128.0*randf(),0.0).rotated(2.0*PI*randf()),"radius":rand_range(32.0,96.0)*rand_range(0.5,1.25),"color":get_random_color(color,color_alt)})
	if num_rays>0:
		logo.rays = {"rays":num_rays,"width":rand_range(2.0,16.0),"offset":rand_range(0.0,32.0),"color":get_random_color(color,color_alt)}
	if num_poly>0:
		logo.poly = []
		for _i in range(num_poly):
			var k := randi()%4+3
			var offset := Vector2(128.0,128.0)
			var points := []
			var colors := []
			var color_logo := get_random_color(color,color_alt)
			var angle := 2.0*PI*randf()
			var radius := rand_range(32.0,96.0)*rand_range(0.5,1.25)
			if randf()<0.33:
				offset += Vector2(rand_range(-128.0,128.0),rand_range(-128.0,128.0))
			points.resize(k)
			colors.resize(k)
			for j in range(k):
				points[j] = offset+Vector2(radius,0.0).rotated(angle+float(j)/float(k)*2.0*PI)
				colors[j] = color_logo
			logo.poly.push_back({"points":points,"colors":colors})
	
	groups[ID] = Group.new(name,desc,type,departments,color,color_alt,logo,country,influence,traits,data)
	


func get_random_color(color,color_alt) -> Color:
	# Given a color and a contrast color, return a random color or one of those two.
	var logo_color : Color
	var rnd := randf()
	if rnd<0.33:
		logo_color = color
	elif rnd<0.66:
		logo_color = color_alt
	elif rnd<0.84:
		logo_color = Color(0.0,0.0,0.0)
	else:
		logo_color = Color(1.0,1.0,1.0)
	return logo_color


func init_world(Menu):
	# Initialize new game.
	randomize()
	
	var player = Actor.new(Menu.get_node("Login/Input/LineEdit").text,Color(0.1,0.3,1.0),"","",15,128,50.0,{"pulse":7},1000,0,37,{},100)
	var ai = Actor.new("Hally",Color(0.13,0.5,1.0),"res://scenes/portraits/character01.tscn","res://scenes/gui/chat_bg/AI.tscn",15,256,60.0,{"pulse":6,"wave":2,"fire_wall":2},0,0,21,{},100)
	ai.desc = "AI_DESC"
	
	actors.player = player
	actors.ai = ai
	Menu.contacts.push_back("ai")
	
	create_groups()
	




func create_data(group) -> Array:
	# Create random file names displayed after successful hack.
	# File names are chosen by the group's traits.
	var num_files := 3+(randi()%4)
	var files := []
	var array := []
	
	for d in GROUP_FILES.keys():
		var has := []
		var has_not := []
		var qualified = true
		for t in d.split(" ",false):
			if "+" in t:
				has.push_back(t.replace("+",""))
			elif "-" in t:
				has_not.push_back(t.replace("-",""))
		for tag in has:
			if !(tag in group.traits):
				qualified = false
				break
		for tag in has_not:
			if tag in group.traits:
				qualified = false
				break
		if qualified:
			array.push_back(GROUP_FILES[d])
	
	for _i in range(num_files):
		var filename := ""
		var size := int(rand_range(2,1024))
		var index := randi()%array.size()
		var ID : int = randi()%array[index].size()
		if typeof(array[index][ID][0])==TYPE_ARRAY:
			for ar in array[index][ID]:
				if typeof(ar)==TYPE_ARRAY:
					filename += ar[randi()%ar.size()]
					if randf()<0.25:
						filename += "-"
					elif randf()<0.2:
						filename += "."
					else:
						filename += "_"
				else:
					filename += ar
			filename = filename.substr(0,filename.length()-1)
		else:
			filename = array[index][ID][randi()%array[index][ID].size()]
		filename += "."+FILE_ENDINGS[randi()%FILE_ENDINGS.size()]
		files.push_back({"name":filename,"size":size})
	
	return files

func get_directory(group) -> String:
	# Return a random directory name displayed after successful hack.
	var array : Array = DIRECTORY_NAMES+group.traits
	return array[randi()%array.size()]

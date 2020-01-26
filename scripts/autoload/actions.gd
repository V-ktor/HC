extends Node

var actions = {}

var pulse_particle = preload("res://scenes/particles/pulse.tscn")
var fire_wall_particle = preload("res://scenes/particles/fire.tscn")
var beam_particle = preload("res://scenes/particles/beam.tscn")
var bombardment_particle = preload("res://scenes/particles/pulse.tscn")
var shocker_particle = preload("res://scenes/particles/pulse.tscn")
var access_particle = preload("res://scenes/particles/anti_virus.tscn")
var anti_virus_particle = preload("res://scenes/particles/anti_virus.tscn")


# pulse #

func pulse(player,ID,effect,amount):
	$"/root/Main".points[ID].attack(player,amount)
	for p in $"/root/Main".points[ID]["connections"]:
		var pi = pulse_particle.instance()
		pi.from = $"/root/Main".points[ID].node
		pi.to = $"/root/Main".points[p].node
		pi.duration = effect.duration
		$"/root/Main/ControlPoints".add_child(pi)
		effect.particles.push_back(pi)

func pulse_timeout(player,ID,effect,amount):
	for p in $"/root/Main".points[ID]["connections"]:
		$"/root/Main".points[p].attack(player,amount)
	for p in effect.particles:
		p.timeout()

func pulse_cancel(player,ID,effect,amount):
	for p in effect.particles:
		p.cancel()

# fire wall #

func fire_wall(player,ID,effect,amount):
	var fire = fire_wall_particle.instance()
	fire.node = $"/root/Main".points[ID].node
	$"/root/Main/ControlPoints".add_child(fire)
	effect.particles.push_back(fire)

func fire_wall_onhit(player,ID,effect,damage,shield):
	if player==effect.player || !effect.active:
		return damage
	var dam = damage-min(shield,damage)
	effect.args[0] = max(effect.args[0]-damage,0)
	if effect.args[0]<=0:
		$"/root/Main".points[ID].remove_effect(effect)
	return dam

func fire_wall_timeout(player,ID,effect,amount):
	for p in effect.particles:
		p.cancel()

func fire_wall_cancel(player,ID,effect,amount):
	for p in effect.particles:
		p.cancel()

func fire_wall_update(player,ID,effect,delta,amount):
	if effect.active:
		effect.node.get_node("VBoxContainer/Label").text = tr("SHIELD")+": "+str(amount).pad_decimals(1)
		effect.node.get_node("VBoxContainer/Label/Bar").value = amount
		effect.node.get_node("VBoxContainer/Label/Bar").max_value = actions["fire_wall"]["args"][0]
	else:
		effect.node.get_node("VBoxContainer/Label").text = ""
		effect.node.get_node("VBoxContainer/Label/Bar").value = 0

# beam cannon #

func beam(player,ID,effect,damage):
	var target = ID
	var defence = -50
	var pi = beam_particle.instance()
	for p in $"/root/Main".points[ID]["connections"]:
		var node = $"/root/Main".points[p]
		var def = -node.control[player]/2
		for i in range(player)+range(player+1,node.control.size()):
			def += node.control[i]
		for eff in node.effects:
			if eff.player!=player && eff.type=="fire_wall":
				def += eff.args[0]
		if def>defence:
			defence = def
			target = p
	effect.args.push_back(target)
	pi.node = $"/root/Main".points[ID].node
	pi.target = $"/root/Main".points[target].node
	$"/root/Main/ControlPoints".add_child(pi)
	effect.particles.push_back(pi)

func beam_update(player,ID,effect,delta,damage,target=null):
	if effect.active:
		var node = $"/root/Main".points[ID]
		var mult = node.control[player]
		var t = 100.0
		for i in range(player)+range(player+1,node.control.size()):
			t += node.control[i]
		mult /= t
		$"/root/Main".points[target].attack(player,delta*mult*damage)
		effect.node.get_node("VBoxContainer/Label").text = tr("DPS")+": "+str(mult*damage).pad_decimals(1)
	else:
		effect.node.get_node("VBoxContainer/Label").text = ""

func beam_timeout(player,ID,effect,damage,target):
	for p in effect.particles:
		p.cancel()

func beam_cancel(player,ID,effect,damage,target):
	for p in effect.particles:
		p.cancel()

# bombardment #

func bombardment(player,ID,effect,damage):
	var target = ID
	var defence = -50
	var pi = beam_particle.instance()
	var cons = $"/root/Main".points[ID].connections
	for p0 in cons:
		for p in $"/root/Main".points[p0].connections:
			if p in cons:
				continue
			var node = $"/root/Main".points[p]
			var def = -node.control[player]/2
			for i in range(player)+range(player+1,node.control.size()):
				def += node.control[i]
			for eff in node.effects:
				if eff.player!=player && eff.type=="fire_wall":
					def += eff.args[0]
			if def>defence:
				defence = def
				target = p
	effect.args.push_back(target)
	pi.node = $"/root/Main".points[ID].node
	pi.target = $"/root/Main".points[target].node
	$"/root/Main/ControlPoints".add_child(pi)
	effect.particles.push_back(pi)

func bombardment_update(player,ID,effect,delta,damage,time,delay,target=null):
	if effect.active:
		var node = $"/root/Main".points[ID]
		var mult = node.control[player]
		var t = 100.0
		for i in range(player)+range(player+1,node.control.size()):
			t += node.control[i]
		mult /= t
		effect.args[1] -= delta*mult
		if effect.args[1]<=0.0:
			$"/root/Main".points[target].attack(player,mult*damage)
			effect.args[1] += effect.args[2]
		effect.node.get_node("VBoxContainer/Label").text = tr("DAMAGE")+": "+str(mult*damage).pad_decimals(1)+"\n"+tr("DELAY")+": "+str(effect.args[1]/mult).pad_decimals(1)+"s"
	else:
		effect.node.get_node("VBoxContainer/Label").text = ""

func bombardment_timeout(player,ID,effect,damage,target):
	for p in effect.particles:
		p.cancel()

func bombardment_cancel(player,ID,effect,damage,target):
	for p in effect.particles:
		p.cancel()

# shocker #

func shocker(player,ID,effect,delay):
	for effect in $"/root/Main".points[ID].effects:
		effect.delay += delay
		effect.duration -= delay
	for p in $"/root/Main".points[ID]["connections"]:
		var pi = shocker_particle.instance()
		pi.from = $"/root/Main".points[ID].node
		pi.to = $"/root/Main".points[p].node
		pi.duration = effect.duration
		$"/root/Main/ControlPoints".add_child(pi)
		effect.particles.push_back(pi)

func shocker_timeout(player,ID,effect,delay):
	for p in $"/root/Main".points[ID]["connections"]:
		for effect in $"/root/Main".points[p].effects:
			effect.delay += delay
			effect.duration -= delay
	for p in effect.particles:
		p.timeout()

func shocker_cancel(player,ID,effect,delay):
	for p in effect.particles:
		p.cancel()

# access #

func access(player,ID,effect):
	var pi = access_particle.instance()
	pi.node = $"/root/Main".points[ID].node
	$"/root/Main/ControlPoints".add_child(pi)
	effect.particles.push_back(pi)

func access_timeout(player,ID,effect):
	for p in effect.particles:
		p.cancel()

func access_cancel(player,ID,effect):
	for p in effect.particles:
		p.cancel()

# anti virus #

func anti_virus(player,ID,effect,amount):
	var pi = anti_virus_particle.instance()
	pi.node = $"/root/Main".points[ID].node
	$"/root/Main/ControlPoints".add_child(pi)
	effect.particles.push_back(pi)

func anti_virus_update(player,ID,effect,delta,damage):
	if effect.active:
		var node = $"/root/Main".points[ID]
		var mult = node.control[player]
		var t = 100.0
		for i in range(player)+range(player+1,node.control.size()):
			t += node.control[i]
		mult /= t
		$"/root/Main".points[ID].attack(player,delta*mult*damage)
		effect.node.get_node("VBoxContainer/Label").text = tr("DPS")+": "+str(mult*damage).pad_decimals(1)
	else:
		effect.node.get_node("VBoxContainer/Label").text = ""

func anti_virus_timeout(player,ID,effect,amount):
	for p in effect.particles:
		p.cancel()

func anti_virus_cancel(player,ID,effect,amount):
	for p in effect.particles:
		p.cancel()


# definitions #

func _ready():
	actions["pulse"] = {
		"name":"PULSE",
		"cpu":5,"size":2,
		"duration":1.0,"delay":1.0,
		"args":[25],
		"cost":250,"compile_time":3.0,"compile_cpu":5,
		"icon":"res://images/icons/pulse.png","image":"res://images/cards/pulse.png"}
	actions["fire_wall"] = {
		"name":"FIRE_WALL",
		"cpu":3,"size":2,
		"duration":12.0,"delay":4.0,
		"args":[75],
		"cost":500,"compile_time":5.0,"compile_cpu":5,
		"icon":"res://images/icons/fire_wall.png","image":"res://images/cards/fire_wall.png"}
	actions["beam"] = {
		"name":"BEAM_CANNON",
		"cpu":4,"cpu_install":3,"size":4,
		"duration":4.0,"delay":3.0,"cooldown":4.0,
		"args":[30],
		"cost":1000,"compile_time":10.0,"compile_cpu":10,
		"icon":"res://images/icons/beam_cannon.png","image":"res://images/cards/beam_cannon.png"}
	actions["bombardment"] = {
		"name":"BOMBARDMENT",
		"cpu":8,"size":5,
		"duration":6.0,"delay":4.0,"cooldown":6.0,
		"args":[50,0.99,1.0],
		"cost":2000,"compile_time":15.0,"compile_cpu":15,
		"icon":"res://images/icons/bombardment.png","image":"res://images/cards/bombardment.png"}
	actions["shocker"] = {
		"name":"SHOCKER",
		"cpu":6,"size":3,
		"duration":1.0,"delay":1.0,
		"args":[2.0],
		"cost":350,"compile_time":5.0,"compile_cpu":5,
		"icon":"res://images/icons/shocker.png","image":"res://images/cards/shocker.png"}
	actions["access"] = {
		"name":"ACCESS",
		"cpu":1,"cpu_install":5,"size":1,
		"duration":14.0,"delay":6.0,
		"args":[],
		"cost":400,"compile_time":5.0,"compile_cpu":7,
		"icon":"res://images/icons/access.png","image":"res://images/cards/access.png"}
	actions["anti_virus"] = {
		"name":"ANTI_VIRUS",
		"cpu":2,"cpu_install":2,"size":1,
		"duration":6.0,"delay":4.0,
		"args":[20],
		"cost":100,"compile_time":2.0,"compile_cpu":3,
		"icon":"res://images/icons/anti_virus.png","image":"res://images/cards/anti_virus.png"}
	

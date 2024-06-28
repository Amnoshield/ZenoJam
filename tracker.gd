extends Node

var num_enemies = 0
var spawners:Array = []
var end
var rng = RandomNumberGenerator.new()
var upgrades = []
var chosen_upgrades = []
var upgrades_main:Array = [
	"res://objects/player/upgrades/double_health.gd",
	"res://objects/player/upgrades/half_health.gd",
	"res://objects/player/upgrades/double_attack_speed.gd",
	
]


var totorial_level = "res://levels/test_scene.tscn"
var first_levels = ["res://levels/test_scene.tscn"]
var second_levels = ["res://levels/test_scene.tscn"]
var third_levels = ["res://levels/test_scene.tscn"]
var boss_levels = ["res://levels/test_scene.tscn"]
var win_screen = "res://Menus/win_screen.tscn"


#need to be reset
var current_level_level
var player_health
var player_max_health
var player_speed
var player_knockback_res
var player_dash_cooldown
var player_attack_cooldown
var player_damage
var player_knockback
var player_parry_cooldown
var go_next_level = false

var level_next


func _ready():
	var counter = 0
	while counter < len(upgrades_main):
		upgrades_main[counter] = load(upgrades_main[counter]).new()
		counter += 1
	
	reset()


func _process(_delta):
	if go_next_level:
		go_next_level = false
		start_next_level()


func spawn_enemies():
	for enemy in spawners:
		enemy.spawnable = true


func remove_enemy():
	num_enemies -= 1
	
	if num_enemies <= 0 and is_instance_valid(end):
		end.open()
	elif num_enemies <= 0:
		print('Fishish crash stopped')


func start_next_level():
	get_tree().change_scene_to_file("res://Menus/pick_part.tscn")


func next_level():
	get_tree().change_scene_to_file(level_next)


func trigger_next_level():
	go_next_level = true
	
	if current_level_level == 1:#level 1
		var _min = 0
		var _max = len(first_levels)-1
		level_next = first_levels[rng.randi_range(_min, _max)]
	elif current_level_level == 2:#level 2
		var _min = 0
		var _max = len(second_levels)-1
		level_next = second_levels[rng.randi_range(_min, _max)]
	elif current_level_level == 3:#level 3
		var _min = 0
		var _max = len(third_levels)-1
		level_next = third_levels[rng.randi_range(_min, _max)]
	elif current_level_level == 4:#Boss
		var _min = 0
		var _max = len(boss_levels)-1
		level_next = boss_levels[rng.randi_range(_min, _max)]
	else:#Win screen
		level_next = win_screen
	
	current_level_level += 1


func reset():
	current_level_level = 1
	player_health = 10
	player_max_health = 10
	player_speed = 100
	player_knockback_res = 0
	player_dash_cooldown = 1
	player_attack_cooldown = 1
	player_damage = 1
	player_knockback = 1000
	player_parry_cooldown = 1
	
	go_next_level = false
	
	for upgrade in upgrades_main:
		if upgrade not in upgrades:
			upgrades.append(upgrade)


func get_upgrade(idx:int):
	var upgrade = upgrades.pop_at(idx)
	chosen_upgrades.append({"obj":upgrade, "name":upgrade.name, 'des':upgrade.discription})
	next_level()


func apply_upgrades():
	for upgrade in chosen_upgrades:
		upgrade["obj"].affect(get_tree().get_nodes_in_group("Player")[0])

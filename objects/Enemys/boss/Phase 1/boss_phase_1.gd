extends CharacterBody2D

@onready var nav:NavigationAgent2D = $NavigationAgent2D
@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
@onready var raycast = $RayCast2D
@onready var attack_cooldown_timer = $attack_cooldown
@onready var random_cooldown_timer = $random_attack_cooldown
@onready var idle_direction = change_idle_dir()
@onready var player_attack_animation = get_tree().get_nodes_in_group("attack")[0]
@onready var dash_timer = $dash_cooldown
@onready var minion = preload("res://objects/Enemys/blob/blob.tscn")

var knockback_strenth = 500
var wait_distence = 75
var wiggle_room = 10
var walk_speed = 40
var random_attack_min = 2
var random_attack_max = 5
var idle_speed = 20
var attacking = false

var knockback = Vector2(0, 0)
var attacking_velocity = Vector2(0, 0)
var attacking_frames = 10
var attacking_frame = 0
var rng = RandomNumberGenerator.new()

#Affected by parts
var health = 10
var max_health = 10
var speed = 100 #used
var knockback_res = 1 #Used
var dash_cooldown = 1#Not used
var attack_cooldown = 1
var damage = 2
var entity_knockback = 1500
var parry_cooldown = 1#Not used
var damage_res = 0 #Used


func _ready():
	Tracker.player_reset()
	player.download_tracker()
	player.set_settings()
	Tracker.apply_upgrades(self)
	$NavigationAgent2D.max_speed = speed
	attack_cooldown_timer.wait_time = attack_cooldown
	dash_timer.wait_time = dash_cooldown
	
	start_random_attack()
	attacking_frame = attacking_frames
	
	player_attack_animation.animation_finished.connect(player_attack)
	
	spawn_minions()


func spawn_minions():
	for x in range(4):
		Tracker.num_enemies += 1
		var mob:Node = minion.instantiate()
		mob.global_position = global_position+Vector2(rng.randi_range(-10, 10), rng.randi_range(-10, 10))
		get_node("..").add_child(mob)
	Tracker.enemy_counter.change_label(Tracker.num_enemies)


func _physics_process(_delta):
	move_and_slide()


func take_damage(oof_damage:int, new_knockback):
	oof_damage -= damage_res
	if oof_damage < 0:
		oof_damage = 0
	health -= oof_damage
	knockback =  new_knockback*knockback_res
	attacking_frame = attacking_frames
	$State_Machine.overide_state("boss_P1_Knockback")
	
	if health <= 0:
		call_deferred("die")


func attack():
	if attack_cooldown_timer.is_stopped() and dash_timer.is_stopped() and not $State_Machine.current_state.name in ["boss_P1_Knockback"]:
		$State_Machine.overide_state("boss_P1_dash_attack")


func change_idle_dir():
	return (rng.randi_range(0, 1)-0.5)*2


func start_random_attack():
	random_cooldown_timer.start(rng.randi_range(random_attack_min, random_attack_max))


func _on_attack_box_area_entered(_area): #this should only apply to the player
	attacking = true
	if attack_cooldown_timer.is_stopped():
		deal_damage()


func deal_damage():
	attack_cooldown_timer.start()
	attacking_frame = attacking_frames
	player.take_damage(damage+rng.randi_range(-1, 1), (player.global_position-global_position).normalized()*knockback_strenth)


func _on_random_attack_cooldown_timeout():
	if not raycast.is_colliding() and nav.distance_to_target() < wait_distence+wiggle_room:
		attack()
	start_random_attack()


func die():
	#Tracker.remove_enemy(self)
	var p2 = load("res://objects/Enemys/boss/Phase 2/boss_phase_2.tscn").instantiate()
	p2.global_position = global_position
	get_node("..").add_child(p2)
	self.queue_free()


func player_attack(_name):
	if not raycast.is_colliding() and nav.distance_to_target() < wait_distence+wiggle_room and rng.randi_range(1, 4) == 1:
		attack()


func _on_attack_cooldown_timeout():
	if attacking:
		deal_damage()


func _on_attack_box_area_exited(_area):
	attacking = false

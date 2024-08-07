extends Area2D

@export var buffer = 0.2
@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
@onready var progress_bar = $"CollisionShape2D/progress bar"
var rng = RandomNumberGenerator.new()

#@export var turning_speed = 1
#@export var dead_zone = 10


func _ready():
	$buffer.wait_time = buffer


func _process(_delta):
	var mouse_pos = get_global_mouse_position()
	mouse_pos -= global_position
	var next_rotation:float = mouse_pos.angle()+deg_to_rad(90)

	set_rotation(next_rotation)
	
	progress_bar.value = ($cooldown.wait_time-$cooldown.time_left)*100


func _unhandled_input(event):
	if event.is_action_pressed("attack"):
		if $cooldown.is_stopped():
			attack()
		else:
			$buffer.start()


func attack():
	var mouse_pos = get_global_mouse_position()
	mouse_pos -= global_position
	set_rotation(mouse_pos.angle()+deg_to_rad(90))
	$CollisionShape2D/Sprite2D.flip_h = rng.randi_range(0, 1)
	$AnimationPlayer.play("sword attack")
	$cooldown.start()
	progress_bar.modulate.a = 0.5
	$AudioStreamPlayer.play()


func _on_area_entered(area:Area2D):
	if area.is_in_group("hurtbox"):
		area.take_damage(
			player.damage,
			(area.global_position-global_position).normalized()*player.entity_knockback,
			$"../../parry2"
		)


func _on_cooldown_timeout():
	progress_bar.modulate.a = 1
	if not $buffer.is_stopped():
		attack()

extends Area2D

@export var damage = 0
@export var cooldown = 1
var enemys:Array = []


func _ready():
	$cooldown.wait_time = cooldown


func _unhandled_input(_event):
	if Input.is_action_just_pressed("parry") and $cooldown.is_stopped():
		$AnimationPlayer.play("parry")
		$cooldown.start()

func add_knockback(knockback):
	print('adding knockback')
	for area in enemys:
		area.take_damage(damage, (area.global_position-global_position).normalized()*knockback)
	enemys.clear()


func _on_area_entered(area:Area2D):
	if area.is_in_group("hurtbox"):
		print('adding enemy: ', area.name)
		enemys.append(area)


func _on_area_exited(area):
	enemys.erase(area)

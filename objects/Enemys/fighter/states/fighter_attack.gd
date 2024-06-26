extends State
class_name fighter_attack

@onready var enemy:CharacterBody2D = $"../.."

func Enter():
	$"../../attack_box/AnimationPlayer".play("Attack")

func Physics_Update(_delta):
	if enemy.attacking_frame >= enemy.attacking_frames-1:
		$"../../attack_cooldown".start()
		Transitioned.emit(self, "Fighter_Idle")
	
	enemy.attacking_frame += 1
	enemy.velocity = enemy.attacking_velocity

extends State
class_name p2_po_pathfind


@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
@onready var nav:NavigationAgent2D = $"../../NavigationAgent2D"
@onready var enemy:CharacterBody2D = $"../.."
@onready var attack_cooldown:Timer = $"../../attack_cooldown"
@onready var ray:RayCast2D = $"../../RayCast2D"


func Physics_Update(_delta):
	nav.set_target_position(player.global_position)
	ray.target_position = player.global_position-enemy.global_position
	ray.force_raycast_update()
	if  not ray.is_colliding() and nav.distance_to_target() < 80:
		Transitioned.emit(self, "p2_po_idle")

	var relitive_pos:Vector2 = nav.get_next_path_position()- enemy.global_position
	enemy.velocity = relitive_pos.normalized()*enemy.speed

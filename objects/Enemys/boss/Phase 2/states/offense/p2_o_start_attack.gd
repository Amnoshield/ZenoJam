extends State
class_name p2_o_start_attack

@onready var enemy:CharacterBody2D = $"../.."
@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
var rng = RandomNumberGenerator.new()


func Enter():
	if rng.randi_range(1, 4):# == 1
		Transitioned.emit(self, "p2_o_dash1")
	else:
		print("attack + big attack")
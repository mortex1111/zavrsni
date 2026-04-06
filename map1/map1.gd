extends Node2D

func _physics_process(delta: float) -> void:
	var enemies = get_tree().get_nodes_in_group("enemy")
	if 0 == enemies.size():
		$Dor.visible = true

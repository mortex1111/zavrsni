extends Node2D

func _physics_process(delta: float) -> void:
	var enemies = get_tree().get_nodes_in_group("enemy")
	if 0 == enemies.size():
		$Dor.visible = true
		$Dor.monitoring = true


func _on_dor_area_entered(area: Area2D) -> void:
	get_tree().change_scene_to_file("res://map3/map_3.tscn")

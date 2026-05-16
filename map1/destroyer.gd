extends Area2D
var temp


func _on_area_entered(area: Area2D) -> void:
	print(area.get_parent())
	temp = area.get_parent()
	while temp.get_parent() != $"..":
		temp = temp.get_parent()
	if temp.name == "Player":
		get_tree().change_scene_to_file("res://scenes/main.tscn") 
	temp.queue_free()


func _on_body_entered(body: Node2D) -> void:
	temp = body.get_parent()
	while temp.get_parent() != $"..":
		temp = temp.get_parent()
	if temp.name == "Player":
		get_tree().change_scene_to_file("res://scenes/main.tscn") 
	temp.queue_free()

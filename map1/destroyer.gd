extends Area2D
var temp


func _on_area_entered(area: Area2D) -> void:
	temp = area.get_parent()
	while temp.get_parent() != $"..":
		temp = temp.get_parent()
	temp.queue_free()


func _on_body_entered(body: Node2D) -> void:
	temp = body.get_parent()
	while temp.get_parent() != $"..":
		temp = temp.get_parent()
	print(temp)
	temp.queue_free()

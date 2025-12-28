extends Area2D

var astronaut

func _on_body_entered(body: Node2D) -> void:
	await get_tree().physics_frame
	astronaut.find_next_pos()
	queue_free()

func activate():
	$CollisionShape2D.disabled = false
	await get_tree().physics_frame
	await get_tree().physics_frame
	queue_free()

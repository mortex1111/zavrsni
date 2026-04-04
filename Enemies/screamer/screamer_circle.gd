extends CharacterBody2D

func _ready() -> void:
	var scale_anim = get_tree().create_tween().tween_property(self,"scale",Vector2(15,15),12.0) 
	await scale_anim.finished 
	queue_free()

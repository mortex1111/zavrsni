extends CharacterBody2D

var speed = 2250


func _physics_process(delta: float) -> void:
	rotate(6)
	var collison = move_and_collide(velocity * delta)
	if collison:
		velocity = velocity.bounce(collison.get_normal())


func _on_dmg_area_area_entered(area: Area2D) -> void:
	queue_free()

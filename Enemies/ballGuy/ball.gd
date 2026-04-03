extends CharacterBody2D

var defS
var speed = 150
func _ready() -> void:
	defS = scale.x

func _physics_process(delta: float) -> void:
	if $Area2D.has_overlapping_bodies():
		if !($Timer.time_left > 0):
			$Timer.start()
		if scale.x < defS * 1.5:
			scale.y -= 0.2
			scale.x += 0.2
		velocity.x = 0
	else:
		velocity.x = speed + randf_range(-100, 100)
		if scale.y < defS * 1.5:
			scale.y += 0.1
			scale.x -= 0.1
	velocity.y += 20
	move_and_slide()

func _on_timer_timeout() -> void:
	if $Area2D.has_overlapping_bodies():
		velocity.y = -800 + randf_range(-400, 400)


func _on_dmg_area_area_entered(area: Area2D) -> void:
	queue_free()

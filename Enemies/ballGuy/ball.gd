extends CharacterBody2D

var defS
var speed = 150
var dir = 1
var distortion = 1
var trueSpeed = 150

func _ready() -> void:
	defS = scale.x

func _physics_process(delta: float) -> void:
	if is_on_wall():
		dir *= -1
	if dir == -1:
		$Sprite2D.flip_h = true
		$Sprite2D.offset.x = -350
	else:
		$Sprite2D.flip_h = false
		$Sprite2D.offset.x = 0
	if $Area2D.has_overlapping_bodies():
		if !($Timer.time_left > 0):
			$Timer.wait_time = randf_range(0.5, 1.5)
			distortion = 2.5 - $Timer.wait_time
			$Timer.start()
		if scale.x < defS * 1.5:
			scale.y -= 0.2 * distortion
			scale.x += 0.2 * distortion
		velocity.x = 0
	else:
		velocity.x = trueSpeed * dir
		if scale.y < defS * 1.5:
			scale.y += 0.1 * distortion
			scale.x -= 0.1 * distortion
	velocity.y += 20
	move_and_slide()

func _on_timer_timeout() -> void:
	if $Area2D.has_overlapping_bodies():
		velocity.y = -1000 - randf_range(0, 600)
		print(velocity.y)
		trueSpeed = (speed + randf_range(-100, 300))


func _on_dmg_area_area_entered(area: Area2D) -> void:
	queue_free()

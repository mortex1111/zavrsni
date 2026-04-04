extends CharacterBody2D

var defS
var dir = -1
var speed = 150

func _ready() -> void:
	$AnimationPlayer.play("fly")

func _physics_process(delta: float) -> void:
	if is_on_wall():
		dir *= -1
		if dir == -1:
			$Sprite2D.flip_h = true
			$Sprite2D/wl.flip_h = false
			$Sprite2D/wr.flip_h = true
			$Sprite2D.offset.x = -374.0
			$Sprite2D/wl.offset.x = -374.0
			$Sprite2D/wr.offset.x = -374.0
		else:
			$Sprite2D.flip_h = false
			$Sprite2D/wl.flip_h = true
			$Sprite2D/wr.flip_h = false
			$Sprite2D.offset.x = 0
			$Sprite2D/wl.offset.x = 0
			$Sprite2D/wr.offset.x = 0
	velocity.x = (speed + randf_range(-50, 50))  * dir
	velocity.y += 30
	move_and_slide()

func boost():
	velocity.y -= randf_range(500, 1100)

func _on_dmg_area_area_entered(area: Area2D) -> void:
	queue_free()

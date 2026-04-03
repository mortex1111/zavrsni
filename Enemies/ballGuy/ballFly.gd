extends CharacterBody2D

var defS
var speed = 150

func _ready() -> void:
	$AnimationPlayer.play("fly")

func _physics_process(delta: float) -> void:
	velocity.x = speed
	velocity.y += 10
	move_and_slide()

func boost():
	velocity.y -= randf_range(50, 120)

func _on_dmg_area_area_entered(area: Area2D) -> void:
	queue_free()

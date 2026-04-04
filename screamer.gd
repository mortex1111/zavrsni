extends CharacterBody2D
var HP = 4
var projectile = preload("res://Enemies/screamer/screamer_circle.tscn")

func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	if not is_on_floor():
			velocity.y += 1000 * delta * 2.1
	if (global_position.x - $"../Player".global_position.x) < 0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	move_and_slide()
func _on_dmg_area_area_entered(area: Area2D) -> void:
	HP -= int(area.editor_description)
	if HP < 1:
		queue_free()

func _on_timer_timeout() -> void:
	$AnimatedSprite2D.play("scream")
	
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "scream":
		var scream_instance = projectile.instantiate()
		get_parent().add_child(scream_instance)
		scream_instance.global_position = global_position
		$AnimatedSprite2D.play("idle")

extends CharacterBody2D
var speed = 2000
var HP = 1
var attacking = false 
var tempAttacking = false 
var dir = -1
var hurting = 1
var attackTimer = 10
var projectile = preload("res://Enemies/caveman/rock.tscn")

func _physics_process(delta: float) -> void:
	if (global_position.x - $"../Player".global_position.x) < 0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	if ($AnimatedSprite2D.animation == "attack" and !$AnimatedSprite2D.is_playing()) and HP > 0:
		$AnimatedSprite2D.play("idle")
		var projectile_instance = projectile.instantiate()
		add_child(projectile_instance)
		if $AnimatedSprite2D.flip_h == true:
			projectile_instance.global_position = global_position + Vector2(-300, 3000)
			#projectile_instance.velocity = Vector2(-20, randf_range(-1000, 1000)).normalized() * speed
		else:
			projectile_instance.global_position = global_position + Vector2(300, 200)
			projectile_instance.velocity = Vector2(200, randf_range(-1000, 1000)).normalized() * speed

func _on_dmg_area_area_entered(area: Area2D) -> void:
	HP -= int(area.editor_description)
	$AnimatedSprite2D.play("death")
	if HP < 1:
		queue_free()


func _on_timer_timeout() -> void:
	$AnimatedSprite2D.play("attack")
	
	

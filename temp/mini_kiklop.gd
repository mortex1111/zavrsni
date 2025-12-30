extends CharacterBody2D
var speed = 200
var HP = 3
var attacking = false 
var tempAttacking = false 
var dir = -1
var hurting = 1

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	mode()
	if !is_on_floor():
		velocity.y = 1000
	if hurting > 0:
		dmgTake(delta)
	elif !attacking:
		$AnimatedSprite2D.scale = Vector2(0.8, 0.8)
		move()
	else:
		$AnimatedSprite2D.scale = Vector2(0.8, 0.8)
		attack()
	move_and_slide()

func mode():
	if !$RayCast2D.is_colliding() and $RayCast2D2.is_colliding():
		attacking = true
	else:
		attacking = false
	if abs($"../Player".global_position - global_position) > abs(($"../Player".global_position - global_position).normalized() * 500):
		$RayCast2D.target_position = ($"../Player".global_position - global_position).normalized() * 500 + Vector2(0, 100)
		$RayCast2D2.target_position = ($"../Player".global_position - global_position).normalized() * 500 + Vector2(0, 100)
	else:
		$RayCast2D.target_position = ($"../Player".global_position - global_position) + Vector2(0, 100)
		$RayCast2D2.target_position = ($"../Player".global_position - global_position) + Vector2(0, 100)

func dmgTake(delta: float):
	hurting -= delta
	$Attack.monitorable = false
	velocity.x = 0
	$AnimatedSprite2D.scale = Vector2(0.5, 0.5)

func move():
	$Attack/right.disabled = true
	$Attack/left.disabled = true
	tempAttacking = false
	$AnimatedSprite2D.play("default")
	if dir == -1:
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.offset.x = 25
		velocity.x = -speed
	else:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.offset.x = 0
		velocity.x = speed

func attack():
	$Attack.monitorable = true
	if tempAttacking == false:
		tempAttacking = true
		if (global_position.x < $"../Player".global_position.x):
			dir = 1
		else:
			dir = -1
	$AnimatedSprite2D.play("attack")
	if dir == -1:
		$Attack/right.disabled = true
		$Attack/left.disabled = false
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.offset.x = 25
		velocity.x = -speed * 2
	else:
		$Attack/right.disabled = false
		$Attack/left.disabled = true
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.offset.x = 0
		velocity.x = speed * 2


@warning_ignore("unused_parameter")
func _on_turn_body_entered(body: Node2D) -> void:
	dir *= -1

@warning_ignore("unused_parameter")
func _on_turn_2_body_exited(body: Node2D) -> void:
	dir *= -1


func _on_dmg_area_area_entered(area: Area2D) -> void:
	HP -= int(area.editor_description)
	$AnimatedSprite2D.play("dmg")
	hurting = 2
	if HP < 1:
		queue_free()

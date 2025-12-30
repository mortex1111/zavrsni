extends CharacterBody2D

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var lgrab: RayCast2D = $Lgrab
@onready var check_up: RayCast2D = $CheckUp
@export var HP: int = 3
@export var accel: float = 0.8
@export var speed: float = 600.0
@export var dodge_speed: float = 2000.0
@export var jump_velocity: float = -1100.0
@export var jump_cutoff: float = -300.0
@export var coyote_time: float = 0.15
@export var jump_buffer_time: float = 0.15
@export var hang_delay: float = 0.2
@export var air_dodge_duration: float = 0.2
@export var max_jumps: int = 2
@export var attack_cool_len: int = 120
@export var attack_len: int = 60
@export var dmgCoolLen: float = 0.3

var scX = 0.8

var dmgLen: float = 0
var invizLen: float = 0
var direction: float = 0
var attack_cool: int = -1
var is_jumping: bool = false
var coyote_timer: float = 0.0
var jumpBufferTimer: float = 0.0
var hang_timer1: float = 0.0
var hang_timer2: float = 0.0
var airDodgeTimer: float = 0.0
var curJumps: int = 0
var attacking = false
var running = false
var knock_back = false
var idle = true
var inAri = false
var hanging = false
var can_move = true
var is_dodging = false
var can_dodge = true
var last_dir = -1

func _physics_process(delta: float) -> void:
	is_hanging()
	timers(delta)
	move_character(delta)
	animations_test()
	animations()
	hit_box()
	move_and_slide()

func is_hanging():
	if lgrab.is_colliding() and !hanging and hang_timer1 <= 0.0:
		if lgrab.get_collider().name == "map":
			if !check_up.is_colliding():
				velocity = Vector2.ZERO
				var grab_position_x
				if last_dir == -1:
					grab_position_x = lgrab.get_collision_point().x +41
				else: 
					grab_position_x = lgrab.get_collision_point().x - 41
				var grab_position_y = lgrab.get_collision_point().y + 41
				self.global_position = Vector2(grab_position_x,grab_position_y)
				hang_timer1 = hang_delay
				hang_timer2 = hang_delay
				hanging = true

func move_character(delta: float) -> void:
	if dmgLen < 0:
		if !is_dodging:
			direction = Input.get_axis("ui_left", "ui_right")
		if hanging:
			is_dodging = false
			hang_timer2 -= delta
		if hanging and direction != 0 and hang_timer2 <= 0.0:
			hanging = false
		if !hanging:
			hang_timer1 -= delta
			
		if not is_on_floor() and !hanging:
			if !is_dodging:
				velocity.y += gravity * delta * 2.1
				accel = 0.02
		else:
			is_jumping = false
			coyote_timer = coyote_time
			curJumps = 0
			accel = 0.04
		if direction != 0 and !hanging and !is_dodging:
			if abs(velocity.x) < speed:
				velocity.x += direction * speed * accel
		elif !is_dodging:
			velocity.x = move_toward(velocity.x, 0, speed / 15)
		if Input.is_action_just_pressed("air_dodge") and !is_on_floor() and !is_dodging and !hanging and can_dodge:
			velocity.y = 0
			velocity.x = 0
			can_dodge = false
			is_dodging = true
		if is_on_floor():
			airDodgeTimer = 0.0
			can_dodge = true
			is_dodging = false
		if is_dodging:
			velocity.x = last_dir * dodge_speed 
			airDodgeTimer += delta
		if airDodgeTimer >= air_dodge_duration:
			airDodgeTimer = 0.0
			velocity.x = 0
			is_dodging = false

		if Input.is_action_just_pressed("ui_accept") and !is_dodging:
			jumpBufferTimer = jump_buffer_time
		if jumpBufferTimer > 0 and can_jump() and !hanging:
			start_jump()
		if Input.is_action_just_released("ui_accept") and is_jumping and velocity.y < jump_cutoff:
			velocity.y = jump_cutoff

func can_jump() -> bool:
	if is_on_floor() or coyote_timer > 0:
		return true
	if curJumps < max_jumps:
		return true
	return false

func start_jump():
	velocity.x = abs(velocity.x) * direction
	velocity.y = jump_velocity
	is_jumping = true
	coyote_timer = 0.0
	jumpBufferTimer = 0.0
	curJumps += 1

func timers(delta: float) -> void:
	if coyote_timer > 0:
		coyote_timer -= delta
	if jumpBufferTimer > 0:
		jumpBufferTimer -= delta
	@warning_ignore("narrowing_conversion")
	attack_cool -= delta
	dmgLen -= delta
	invizLen -= delta
	

func animations_test():
	if velocity == Vector2.ZERO:
		idle = true
	else:
		idle = false
	if velocity.x != 0 and !is_dodging:
		running = true
	else:
		running = false
	if Input.is_action_pressed("attack") and attack_cool <= 0:
		attack_cool = attack_cool_len
	if attack_cool < attack_len:
		attacking = false
	else:
		attacking = true
	if velocity.y != 0:
		inAri = true
	else:
		inAri = false

func animations():
	if dmgLen > 0:
		$AnimationPlayer.play("air_dodge")
	elif attacking:
		$AnimationPlayer.play("attack")
	elif running:
		$AnimationPlayer.play("Run")
	elif hanging:
		$AnimationPlayer.play("hanging")
	elif idle:
		$AnimationPlayer.play("hanging")
	elif is_dodging:
		$AnimationPlayer.play("air_dodge")
	
	
	if direction != 0:
		last_dir = direction
	if last_dir > 0:
		$Sprite2D.flip_h = false
		$Sprite2D.offset.x = 0
		$attack/CollisionShape2D2.position = abs($attack/CollisionShape2D2.position)
		$Lgrab.position = Vector2(47.5, -65)
		$Lgrab.target_position.x = 52.5
		$CheckUp.position = Vector2(100, -80)
	else:
		$Sprite2D.flip_h = true
		$Sprite2D.offset.x = 45
		$attack/CollisionShape2D2.position = abs($attack/CollisionShape2D2.position) * -1
		$Lgrab.position = Vector2(-47.5, -65)
		$Lgrab.target_position.x = -52.5
		$CheckUp.position = Vector2(-100, -80)
	
	if invizLen > 0:
		modulate = Color(1,0,0, 0.5)
	else:
		modulate = Color(1,1,1)

func hit_box():
	if invizLen > 0:
		$dmgHitbox/CollisionShape2D.disabled = true
	else:
		$dmgHitbox/CollisionShape2D.disabled = false
	if $AnimationPlayer.is_playing() and $AnimationPlayer.current_animation == "attack":
		$attack/CollisionShape2D2.disabled = false
	else: 
		$attack/CollisionShape2D2.disabled = true

func _on_dmg_hitbox_area_entered(area: Area2D) -> void:
	hanging = false
	velocity = (global_position - area.global_position).normalized() * 400
	HP -= int(area.editor_description)
	dmgLen = dmgCoolLen
	invizLen = dmgCoolLen * 5


func _on_attack_area_entered(area: Area2D) -> void:
	print("you hit an enemy")

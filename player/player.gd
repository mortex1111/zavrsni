extends CharacterBody2D

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var lgrab: RayCast2D = $Lgrab
@onready var check_up: RayCast2D = $Lgrab/CheckUp
@export var HP: int = 3
@export var accel: float = 0.8
@export var speed: float = 600.0
@export var jump_velocity: float = -1100.0
@export var jump_cutoff: float = -300.0
@export var coyote_time: float = 0.15
@export var jump_buffer_time: float = 0.15
@export var hang_delay: float = 0.2
@export var max_jumps: int = 2
@export var attack_cool_len: int = 120
@export var attack_len: int = 60

var direction = 0
var attack_cool: int = -1
var is_jumping: bool = false
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var hang_timer1: float = 0.0
var hang_timer2: float = 0.0
var jumps_done: int = 0
var attacking = false
var running = false
var knock_back = false
var idle = true
var inAri = false
var hanging = false
var can_move = true

func _physics_process(delta: float) -> void:
	is_hanging()
	handle_timers(delta)
	move_character(delta)
	animations_test()
	animations()
	hit_box()
	move_and_slide()

func is_hanging():
	if lgrab.is_colliding() and !hanging and hang_timer1 <= 0.0:
		if lgrab.get_collider().name == "temp":
			if !check_up.is_colliding():
				velocity = Vector2.ZERO
				var grab_position_x = lgrab.get_collision_point().x - 41
				var grab_position_y = lgrab.get_collision_point().y + 41
				self.position = Vector2(grab_position_x,grab_position_y)
				hang_timer1 = hang_delay
				hang_timer2 = hang_delay
				hanging = true

func move_character(delta: float) -> void:
		direction = Input.get_axis("ui_left", "ui_right")
		if hanging:
			hang_timer2 -= delta
		if hanging and direction != 0 and hang_timer2 <= 0.0:
			hanging = false
		if !hanging:
			hang_timer1 -= delta
			
		if not is_on_floor() and !hanging:
			velocity.y += gravity * delta * 2.1
			accel = 0.02
		else:
			is_jumping = false
			coyote_timer = coyote_time
			jumps_done = 0
			accel = 0.04
		if direction != 0 and !hanging:
			if abs(velocity.x) < speed:
				velocity.x += direction * speed * accel
		else:
			velocity.x = move_toward(velocity.x, 0, speed / 15)
		if Input.is_action_just_pressed("ui_accept"):
			jump_buffer_timer = jump_buffer_time
		if jump_buffer_timer > 0 and can_jump() and !hanging:
			start_jump()
		if Input.is_action_just_released("ui_accept") and is_jumping and velocity.y < jump_cutoff:
			velocity.y = jump_cutoff

func can_jump() -> bool:
	if is_on_floor() or coyote_timer > 0:
		return true
	if jumps_done < max_jumps:
		return true
	return false

func start_jump():
	velocity.y = jump_velocity
	is_jumping = true
	coyote_timer = 0.0
	jump_buffer_timer = 0.0
	jumps_done += 1

func handle_timers(delta: float) -> void:
	if coyote_timer > 0:
		coyote_timer -= delta
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
	attack_cool -= delta

func animations_test():
	if velocity == Vector2.ZERO:
		idle = true
	else:
		idle = false
	if velocity.x != 0:
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
	if attacking:
		$AnimationPlayer.play("attack")
	elif running:
		$AnimationPlayer.play("Run")
	elif hanging:
		$AnimationPlayer.play("hanging")
	elif idle:
		$AnimationPlayer.play("idle")

func hit_box():
	if $AnimationPlayer.is_playing() and $AnimationPlayer.current_animation == "attack":
		$attack/CollisionShape2D2.disabled = false
	else: 
		$attack/CollisionShape2D2.disabled = true

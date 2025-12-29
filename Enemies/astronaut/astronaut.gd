extends CharacterBody2D

var check = preload("res://Enemies/astronaut/astronaut_check.tscn")
var projectile = preload("res://Enemies/astronaut/astronaut_projectile.tscn")

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var shoot_delay: float = 4.0
@export var radius: float = 400.0
@export var speed: float = 75

var shoot_timer: float = 0.0
var player_in_range = false
var traveling = false
var next_pos

func find_next_pos():
	var check_instance = check.instantiate()
	add_sibling(check_instance)
	check_instance.astronaut = self
	check_instance.activate()
	var angle = randf() * TAU
	var distance = sqrt(randf()) * radius
	next_pos = global_position + Vector2(cos(angle), sin(angle)) * distance
	check_instance.global_position = next_pos


func _physics_process(delta: float) -> void:
	
	if player_in_range and shoot_timer >= shoot_delay:
		$AnimationPlayer.play("shoot")
		shoot_timer = 0.0
	else:
		shoot_timer += delta

	if !traveling:
		find_next_pos()
		traveling = true
	
	if traveling:
		global_position = global_position.move_toward(next_pos, speed * delta)

	if global_position == next_pos:
		find_next_pos()
	
	move_and_slide()

func shoot():
	var projectile_instance = projectile.instantiate()
	add_child(projectile_instance)
	projectile_instance.global_position = $Marker2D.global_position

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") :
		player_in_range = true
		
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player") :
		player_in_range = false

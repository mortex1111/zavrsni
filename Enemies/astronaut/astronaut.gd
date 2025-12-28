extends CharacterBody2D

var check = preload("res://Enemies/astronaut/astronaut_check.tscn")

@export var radius: float = 600.0
@export var speed: float = 50

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
	if !traveling:
		find_next_pos()
		traveling = true
	
	if traveling:
		global_position = global_position.move_toward(next_pos, speed * delta)

	if global_position == next_pos:
		find_next_pos()
	
	move_and_slide()

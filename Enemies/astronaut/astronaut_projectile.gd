extends CharacterBody2D

@export var speed: int = 200

@onready var player = get_tree().get_first_node_in_group("Player")

var player_pos 

func _ready() -> void:
	player_pos = player.global_position
	look_at(player_pos)

func _physics_process(delta: float) -> void:
	global_position = global_position.move_toward(player_pos, speed * delta)
	
	if global_position == player_pos:
		queue_free()

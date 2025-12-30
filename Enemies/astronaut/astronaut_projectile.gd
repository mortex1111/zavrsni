extends Area2D

@export var speed: int = 400

@onready var player = get_tree().get_first_node_in_group("Player")


var player_pos
var player_dir  

func _ready() -> void:
	player_pos = player.global_position
	player_dir = global_position.direction_to(player_pos)
	look_at(player_pos)

func _physics_process(delta: float) -> void:
	global_position += player_dir * speed * delta

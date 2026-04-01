extends Control

@onready var hand_test: Node2D = $Stickman/HandTest
@onready var stickman: AnimatedSprite2D = $Stickman/AnimatedSprite2D
@onready var hand: Node2D = $Stickman/Hand

func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	hand_test.rotation_degrees = -90
	hand_test.look_at(get_global_mouse_position())
	hand_test.rotation += deg_to_rad(90)
	
	if hand_test.rotation_degrees < 0 and hand_test.rotation_degrees > -160:
		hand.look_at(get_global_mouse_position())
		hand.rotation += deg_to_rad(90)
	
func _on_animated_sprite_2d_animation_finished() -> void:
	stickman.play("idle")
	hand.show()

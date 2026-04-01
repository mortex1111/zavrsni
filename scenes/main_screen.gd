extends Control

@onready var hand_test: Node2D = $Stickman/HandTest
@onready var stickman: AnimatedSprite2D = $Stickman/AnimatedSprite2D
@onready var hand: Node2D = $Stickman/Hand

@export var main_level: String
@export var settings_scene: String

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


func _on_start_button_down() -> void:
	var move_anim = get_tree().create_tween().tween_property($Explosion,"position",Vector2(0,0),0.5)
	var hand_anim = get_tree().create_tween().tween_property(hand,"rotation_degrees",0,0.2) 
	self.process_mode = Node.PROCESS_MODE_DISABLED
	await move_anim.finished
	get_parent().switch_scenes(main_level)



func _on_stats_button_down() -> void:
	pass


func _on_settings_button_down() -> void:
	var move_anim = get_tree().create_tween().tween_property($Explosion,"position",Vector2(0,0),0.5)
	var hand_anim = get_tree().create_tween().tween_property(hand,"rotation_degrees",0,0.2) 
	self.process_mode = Node.PROCESS_MODE_DISABLED
	await move_anim.finished
	get_parent().switch_scenes(settings_scene)


func _on_exit_button_down() -> void:
	var move_anim = get_tree().create_tween().tween_property($Explosion,"position",Vector2(0,0),0.5)
	hand.rotation_degrees = 0
	self.process_mode = Node.PROCESS_MODE_DISABLED
	await move_anim.finished
	get_tree().quit()

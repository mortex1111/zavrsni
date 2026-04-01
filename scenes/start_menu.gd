extends Control

@export var main_screen : String

func _input(event: InputEvent) -> void:
	if !event is InputEventMouseMotion:
		get_parent().switch_scenes(main_screen)

extends Node2D

func  _ready() -> void:
	$Label.text = str(Global.kills)
	await get_tree().create_timer(10.0).timeout
	get_tree().change_scene_to_file("res://scenes/main.tscn")

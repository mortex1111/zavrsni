extends Control

var current_scene 

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("air_dodge"):
		print("gay")

func _ready() -> void:
	for child in get_children():
		if child.is_in_group("Scene"):
			current_scene = child

func switch_scenes(scene_path):
	print(current_scene)
	current_scene.queue_free()
	var scene = load(scene_path)
	var scene_instance = scene.instantiate()
	current_scene.queue_free()
	add_child(scene_instance)
	current_scene = scene_instance

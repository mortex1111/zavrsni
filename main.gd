extends Control

var current_scene 
@onready var ui: CanvasLayer = $CanvasLayer


func _physics_process(delta: float) -> void:
	if get_tree().get_first_node_in_group("Player") != null:
		var knockval = (get_tree().get_first_node_in_group("Player").knockVal - 1)*100
		$CanvasLayer/UI/HBoxContainer/knockValText.text = str(snapped(knockval, 0.01)) + "%"
		

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
	move_child(scene_instance, 0)
	current_scene = scene_instance

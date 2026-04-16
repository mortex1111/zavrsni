extends Control


var action_to_remap 
var remmaping_button
var is_remapping = false

@export var main_screen: String

@onready var input = preload("res://scenes/input_scene.tscn")
@onready var input_list: VBoxContainer = $Controls2/MarginContainer/VBoxContainer

var input_actions = {
	"attack" : "Attack",
	"right" : "Right",
	"left" : "Left",
	"air_dodge" : "Air dodge",
	"jump" : "Jump"
}

func _input(event: InputEvent) -> void:
	if is_remapping and (event is InputEventKey or (event is InputEventMouseButton and event.is_pressed())):
		if event.as_text() != "Escape":
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			
			print(action_to_remap, event.as_text())
			
			remmaping_button.text = event.as_text()

			is_remapping = false
			remmaping_button = null
			action_to_remap = null
			
			accept_event()
	if event.as_text() == "Escape":
		get_parent().switch_scenes(main_screen)


func _ready() -> void:
	_create_list()

func _create_list():
	for item in input_list.get_children():
		item.queue_free()

	for action in input_actions:
		var input_instance = input.instantiate()
		input_list.add_child(input_instance)
		
		input_instance.label.text = input_actions[action]
		
		var events = InputMap.action_get_events(action)
		input_instance.button.text = events[0].as_text().trim_suffix(" - Physical")
		
		input_instance.button.pressed.connect(_on_input_button_pressed.bind(input_instance.button,action))

func _on_input_button_pressed(button, action):
	if !is_remapping:
		remmaping_button = button
		action_to_remap = action
		is_remapping = true
		button.text = "Press any key"



func _on_master_value_changed(value: float) -> void:
	var busindex = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_linear(busindex,value)

func _on_music_value_changed(value: float) -> void:
	var busindex = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_linear(busindex,value)

func _on_sfx_value_changed(value: float) -> void:
	var busindex = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_linear(busindex,value)

func _on_option_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_back_button_down() -> void:
	get_parent().switch_scenes(main_screen)

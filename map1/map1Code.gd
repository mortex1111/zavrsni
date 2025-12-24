extends Node2D

func _ready():
	$objects/sRoc1/AnimationPlayer.current_animation = "takeoff"
	$objects/sRoc1/AnimationPlayer.stop()
	$objects/sRoc2/AnimationPlayer.current_animation = "takeoff_2"
	$objects/sRoc2/AnimationPlayer.stop()

func _on_lever_1_area_entered(area: Area2D) -> void:
	$objects/levers/Lever1/AnimationPlayer.play("leverSw")
	await get_tree().create_timer(2.5).timeout
	$objects/sRoc1/AnimatedSprite2D.play("default")
	$objects/levers/Lever1/AnimationPlayer.active = false
	$objects/sRoc1/AnimationPlayer.play("takeoff")

func _on_lever_2_area_entered(area: Area2D) -> void:
	$objects/levers/Lever2/AnimationPlayer.play("leverSw")
	await get_tree().create_timer(2.5).timeout
	$objects/sRoc2/AnimatedSprite2D.play("default")
	$objects/levers/Lever2/AnimationPlayer.active = false
	$objects/sRoc2/AnimationPlayer.play("takeoff_2")

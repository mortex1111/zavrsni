extends Node2D

var kiklop = preload("res://Enemies/miniKiklop/mini_kiklop.tscn")
var sc = preload("res://Enemies/screamer/screamer.tscn")
var ca = preload("res://Enemies/caveman/cave_man.tscn")
var l = []
var eList = [preload("res://Enemies/astronaut/astronaut.tscn"), preload("res://Enemies/ballGuy/ball.tscn"), preload("res://Enemies/ballGuy/ball_fly.tscn")]
var wave = 1

func _ready():
	l = [$spawnerMain/spawnK, $spawnerMain/spawnK2, $spawnerMain/spawnK3, $spawnerMain/spawnG, $spawnerMain/spawnG2, $spawnerMain/spawnG3, $spawnerMain/spawnG4, $spawnerMain/spawnG5, $spawnerMain/spawnG6, $spawnerMain/spawn, $spawnerMain/spawn2, $spawnerMain/spawn3, $spawnerMain/spawn4, $spawnerMain/spawn5, $spawnerMain/spawn6, $spawnerMain/spawn7, $spawnerMain/spawn8, $spawnerMain/spawn9, $spawnerMain/spawn10, $spawnerMain/spawn11, $spawnerMain/spawn12, $spawnerMain/spawn13, $spawnerMain/spawn14]
	await get_tree().create_timer(1.0).timeout

func _physics_process(delta):
	var enemies = get_tree().get_nodes_in_group("enemy")

	if enemies.size() <= 3:
		spawn()

func spawn():
	for i in range(3):
		if randf_range(0, 6 + (wave / 2.0)) > 4:
			var instance = kiklop.instantiate()
			instance.global_position = l[i].global_position
			add_child(instance)
	for i in range(3, 9):
		if randf_range(0, 4 + (wave / 2.0)) > 4:
			var instance
			if randi_range(0, 1) == 0:
				instance = sc.instantiate()
				instance.global_position = l[i].global_position
			else:
				instance = ca.instantiate()
				instance.global_position = l[i].global_position + Vector2(0, -200)
			add_child(instance)
	for i in range(10, 23):
		if randf_range(0, 6 + wave) > 5:
			var instance = eList.pick_random().instantiate()
			instance.global_position = l[i].global_position
			add_child(instance)

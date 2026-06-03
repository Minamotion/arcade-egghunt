class_name Game extends Node


const special_egg_scene = preload("res://scenes/gameplay/special/special.tscn")
const egg_scene = preload("res://scenes/gameplay/egg/egg.tscn")
const ghost_scene = preload("res://scenes/gameplay/ghost/ghost.tscn")
const player_scene = preload("res://scenes/gameplay/player/player.tscn")


@onready var music: AudioStreamPlayer= %Music


@onready var in_game_hud:= %InGameHud
@onready var countdown:= %Countdown


@onready var tilemap:= %Tilemap
@onready var map:= %Map
var eggable_cells: Array[Vector2i]


@onready var camera:= %Camera
@onready var sounds:= %Sounds


var freezed_timer: float= 0.0


func _ready() -> void:
	Session.game = self
	Session.eggs = 0
	Session.health = Session.max_health
	for cell in tilemap.get_used_cells():
		if tilemap.get_cell_tile_data(cell).get_custom_data("isEggable"):
			eggable_cells.push_front(cell)
	spawn_player()
	print("Gameplay set up, waiting for countdown...\n")


func start():
	music.play()
	in_game_hud.show()
	for i in 256: spawn_egg()
	print("Game started!\n")


func _process(delta: float) -> void:
	if Session.player is Player:
		camera.global_position = Session.player.global_position
	freezed_timer -= delta


func spawn_special_egg():
	var node = special_egg_scene.instantiate()
	node.global_position = Vector2(eggable_cells.pick_random() * 16) + Vector2(8,8) + Vector2(randi_range(-4,4),randi_range(-4,4))
	map.call_deferred("add_child", node)
	print("Spawned special egg at ", node.global_position)


func spawn_egg():
	var node = egg_scene.instantiate()
	node.global_position = Vector2(eggable_cells.pick_random() * 16) + Vector2(8,8) + Vector2(randi_range(-4,4),randi_range(-4,4))
	map.call_deferred("add_child", node)
	print("Spawned egg at ", node.global_position)


func spawn_ghost():
	var node = ghost_scene.instantiate()
	node.global_position = Vector2(eggable_cells.pick_random() * 16) + Vector2(8,8)
	map.call_deferred("add_child", node)
	print("Spawned ghost at ", node.global_position)


func spawn_player():
	var node = player_scene.instantiate()
	node.global_position = Vector2(eggable_cells.pick_random() * 16) + Vector2(8,8)
	map.call_deferred("add_child", node)
	print("Spawned player at ", node.global_position)


func end():
	print("\nGame ended")
	music.stop()
	for egg in get_tree().get_nodes_in_group("egg"): egg.queue_free()
	for enemy in get_tree().get_nodes_in_group("enemy"): enemy.queue_free()


func show_results_screen():
	if Session.eggs > 0:
		print("Showing results screen...\n")
		get_tree().call_deferred("change_scene_to_file","res://scenes/results/results.tscn")
	else:
		print("you monster...")
		get_tree().call_deferred("change_scene_to_file","res://scenes/starving/starving.tscn")


func show_game_over():
	print("\nPlayer died, showing game over screen...\n")
	if (randi_range(1, 10) == 1) and not Session.starving:
		print("OR NOT!!!!!!!!!!!!!!!!!!!!! LOL!!!!!!!!!!!!!!!!!!!!!")
		get_tree().call_deferred("change_scene_to_file","res://scenes/rick/rick.tscn")
	else:
		get_tree().call_deferred("change_scene_to_file","res://scenes/gameover/gameover.tscn")


func show_effect(effect: String):
	match effect:
		"noghost":
			sounds.get_node_or_null("NoGhost").play()
		"freeze":
			sounds.get_node_or_null("Freeze").play()
		"clock":
			sounds.get_node_or_null("Clock").play()

extends Node


var hiscore: int
var seen_story: bool= false


var _about_to_close_program: bool= false


var game: Game
var player: Player


var starving: bool= false


var eggs: int= 0:
	set(value):
		if value <= 0:
			eggs = 0
		eggs = value


var max_health: int= 3:
	set(value):
		if value <= 0:
			max_health = 1
		else:
			max_health = value
		if health < max_health:
			health = max_health


var health: int= max_health:
	set(value):
		if value <= 0:
			health = 0
		elif value >= max_health:
			health = max_health
		else:
			health = value


func close_window():
	if not _about_to_close_program:
		_about_to_close_program = true
		Save.save_file()
		print("\nClosing...")
		get_tree().change_scene_to_file("res://scenes/thanks/thanks.tscn")


func _ready():
	get_window().close_requested.connect(close_window)

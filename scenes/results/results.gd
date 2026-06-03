extends Node


var can_exit: bool= false


@onready var results:= %Results
@onready var winner_tune:= %WinnerTune
@onready var instructions:= %Instructions


func _ready() -> void:
	Session.starving = false
	results.text = results.text.format({
		"score": Session.eggs,
		"hiscore": str("HiScore: ", Session.hiscore) if Session.eggs <= Session.hiscore else "[color=yellow]New HiScore![/color]"
	})
	if Session.eggs > Session.hiscore:
		print("New highscore obtained! Saving...")
		Session.hiscore = Session.eggs
		Save.save_file()
	await winner_tune.finished
	can_exit = true


func _process(_delta: float) -> void:
	instructions.visible = can_exit
	if can_exit:
		if Input.is_action_just_pressed("game_a"):
			get_tree().change_scene_to_file("res://scenes/gameplay/gameplay.tscn")
		if Input.is_action_just_pressed("game_b"):
			Session.close_window()

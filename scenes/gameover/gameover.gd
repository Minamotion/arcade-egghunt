extends Control


var can_exit: bool= false


@onready var timer:= %Timer
@onready var game_over_tune:= %GameOverTune
@onready var instructions:= %Instructions


func _ready() -> void:
	await timer.timeout
	can_exit = true
	game_over_tune.play()


func _process(_delta: float) -> void:
	instructions.visible = can_exit
	if can_exit:
		if Input.is_action_just_pressed("game_a"):
			get_tree().change_scene_to_file("res://scenes/gameplay/gameplay.tscn")
		if Input.is_action_just_pressed("game_b"):
			Session.close_window()

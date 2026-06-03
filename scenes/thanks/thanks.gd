extends Control


@onready var label:= %Label


func _ready() -> void:
	if Session.starving:
		label.text = '[font="uid://prcqxo2smajm"][font_size=8]You\'re not leaving[/font_size][/font]'
	else:
		label.text = '[font="uid://prcqxo2smajm"]Thanks for playing![/font]'


func _on_timer_timeout() -> void:
	if Session.starving:
		Session._about_to_close_program = false
		get_tree().change_scene_to_file("res://scenes/gameplay/gameplay.tscn")
	else:
		OS.kill(OS.get_process_id())

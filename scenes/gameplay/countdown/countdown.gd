class_name Countdown extends Node2D


@onready var animator:= %Animator


var time_left: float= 120
var depleting_time: bool= false


func _after_one_second() -> void:
	animator.play("countdown")
	await animator.animation_finished
	depleting_time = true
	Session.game.start()


func _process(delta: float) -> void:
	if depleting_time:
		time_left -= delta
		if (time_left <= 0):
			time_left = 0
			depleting_time = false
			_on_timer_timeout()


func _on_timer_timeout():
	animator.play("timeout")
	Session.game.end()
	await animator.animation_finished
	Session.game.show_results_screen()

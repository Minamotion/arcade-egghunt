extends Node2D


@onready var animator: AnimationPlayer= %Animator


func _ready() -> void:
	animator.play("intro")
	await animator.animation_finished
	get_tree().change_scene_to_file("res://scenes/titlescreen/titlescreen.tscn")

extends RichTextLabel


@onready var rick:= %Rick


func _ready() -> void:
	await rick.finished
	get_tree().change_scene_to_file("res://scenes/gameplay/gameplay.tscn")

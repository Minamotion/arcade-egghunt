extends Control


@onready var starve_text:= %StarveText


func _ready() -> void:
	var why: PackedStringArray= [
		"THEY DON'T DESERVE THIS!!",
		"FEED IT!!",
		"WHY'D YOU DO THAT?!",
		"THEY'RE STARVING!!",
		"YOU LET IT STARVE!!",
#		"KILL YOURSELF!!",
		"YOU'RE KILLING THEM!!"
	]
	starve_text.text = starve_text.text.format({"why":why[randi_range(0,why.size()-1)]})
	Session.starving = true

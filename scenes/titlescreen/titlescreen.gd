extends Node


@onready var snd_earn := %Earn
@onready var titlescreen := %Titlescreen
@onready var storylayer := %Storylayer
@onready var storygraphic := %StoryGraphic
@onready var storytext := %StoryText
@onready var highscore := %Highscore


@onready var arcade_machine := %ArcadeMachine
@onready var story_sequence := %StorySequence


var stage: int= 0


func _ready():
	highscore.text = highscore.text.format({"hiscore": Session.hiscore})


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("game_a"):
		stage += 1
		match stage:
			1:
				if Session.seen_story:
					get_tree().change_scene_to_file("res://scenes/gameplay/gameplay.tscn")
					return
				#region [TEMPORAL STUFF]
				arcade_machine.stop()
				story_sequence.play()
				#endregion
				titlescreen.hide()
				storygraphic.show()
				storylayer.show()
				storygraphic.frame = 0
				storytext.text = '[font="uid://prcqxo2smajm"][font_size=8]You are you (fast and hungry)[/font_size][/font]'
			2:
				storygraphic.frame += 1
				storytext.text = '[font="uid://prcqxo2smajm"][font_size=8]You love eggs (they probably love you too)[/font_size][/font]'
			3:
				storygraphic.frame += 1
				storytext.text = '[font="uid://prcqxo2smajm"][font_size=8]Ghosts hate you (stun you and want to kill you)[/font_size][/font]'
			4:
				storygraphic.frame += 1
				storytext.text = '[font="uid://prcqxo2smajm"][font_size=8]Eggs heal you from otherworldly injuries (while not stunned, of course)[/font_size][/font]'
			5:
				storygraphic.frame += 1
				storytext.text = '[font="uid://prcqxo2smajm"][font_size=8]Eat the most eggs before time runs out (2 minutes)[/font_size][/font]'
			6:
				storygraphic.hide()
				storytext.text = '[font="uid://prcqxo2smajm"][font_size=8]Don\'t die (It\'s stupid)[/font_size][/font]'
			_:
				Session.seen_story = true
				get_tree().change_scene_to_file("res://scenes/gameplay/gameplay.tscn")
				return
		snd_earn.play()

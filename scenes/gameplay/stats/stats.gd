extends MarginContainer


@onready var egg_stat_label: RichTextLabel= %EggStatLabel
@onready var egg_stat_placeholder: String= egg_stat_label.text


@onready var health_stat_label: RichTextLabel= %HealthStatLabel
@onready var health_stat_placeholder: String= health_stat_label.text


@onready var timer_stat_label: RichTextLabel= %TimerStatLabel
@onready var timer_stat_placeholder: String= timer_stat_label.text


func _process(_delta: float) -> void:
	egg_stat_label.text = egg_stat_placeholder.format({"egg": Session.eggs})
	health_stat_label.text = health_stat_placeholder.format({"hp": Session.health,"maxhp": Session.max_health})
	timer_stat_label.text = timer_stat_placeholder.format({"timer": String.num(Session.game.countdown.time_left,1)})

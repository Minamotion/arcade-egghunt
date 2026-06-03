class_name SpecialEgg extends Egg


enum SpecialEggType {
	freeze = 0,
	no_ghosts = 1,
	bad_egg = 2,
	more_time = 3
}


var special_type: SpecialEggType= 0 as SpecialEggType


@onready var sprite: Sprite2D= %Sprite
@onready var timer: Timer= %Timer
var _v_frames: int= 0
var disabled: bool= false


func _ready() -> void:
	var spinwheel: Array[SpecialEggType]= []
	for i in 2:
		spinwheel.append(SpecialEggType.more_time)
		spinwheel.append(SpecialEggType.no_ghosts)
	for i in 6:
		spinwheel.append(SpecialEggType.freeze)
	for i in 8:
		spinwheel.append(SpecialEggType.bad_egg)
	special_type = spinwheel.pick_random()
	sprite.frame = special_type as int


func eat() -> bool:
	if disabled:
		return false
	match special_type:
		SpecialEggType.freeze:
			Session.game.freezed_timer = 10
			Session.game.show_effect("freeze")
		SpecialEggType.no_ghosts:
			for ghost in get_tree().get_nodes_in_group("enemy"):
				ghost.queue_free()
			for i in 9:
				Session.game.spawn_ghost()
			Session.game.show_effect("noghost")
		SpecialEggType.bad_egg:
			if not Session.player.hurt():
				return false
			if Session.eggs <= 0:
				Session.eggs = 0
			else:
				Session.eggs -= 1
		SpecialEggType.more_time:
			Session.game.countdown.time_left = 20
			Session.game.show_effect("clock")
		_:
			print("What?")
	Session.game.spawn_special_egg()
	queue_free()
	return true


func _process(_delta: float) -> void:
	match special_type:
		SpecialEggType.freeze:
			disabled = Session.game.freezed_timer >= -3
		SpecialEggType.no_ghosts:
			disabled = (get_tree().get_nodes_in_group("enemy").size() < 15) or (Session.game.freezed_timer >= 0)
		SpecialEggType.more_time:
			disabled = Session.game.countdown.time_left > 20
	
	sprite.modulate = Color.BLACK if disabled else Color.WHITE
	if timer.time_left <= 5:
		visible = _v_frames %2 == 1
		_v_frames += 1
	else:
		visible = true


func _on_timer_timeout() -> void:
	Session.game.spawn_special_egg()
	queue_free()

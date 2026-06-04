class_name SpecialEgg extends Egg


enum SpecialEggType {
	FREEZE = 0,
	NO_GHOSTS = 1,
	BAD_EGG = 2,
	MORE_TIME = 3,
	FLAG = 4
}


var special_type: SpecialEggType= 0 as SpecialEggType


@onready var sprite: Sprite2D= %Sprite
@onready var timer: Timer= %Timer
var _v_frames: int= 0
var disabled: bool= false


func _ready() -> void:
	var spinwheel: Array[SpecialEggType]= []
	for i in 2:
		spinwheel.append(SpecialEggType.MORE_TIME)
		spinwheel.append(SpecialEggType.NO_GHOSTS)
	for i in 6:
		spinwheel.append(SpecialEggType.FREEZE)
	for i in 8:
		spinwheel.append(SpecialEggType.BAD_EGG)
	special_type = spinwheel.pick_random()
	sprite.frame = special_type as int


func eat() -> bool:
	if disabled:
		return false
	match special_type:
		SpecialEggType.FREEZE:
			Session.game.freezed_timer = 10
			Session.game.show_effect("freeze")
		SpecialEggType.NO_GHOSTS:
			for ghost in get_tree().get_nodes_in_group("enemy"):
				ghost.queue_free()
			for i in 9:
				Session.game.spawn_ghost()
			Session.game.show_effect("noghost")
		SpecialEggType.BAD_EGG:
			if not Session.player.hurt():
				return false
			Session.eggs -= 1
		SpecialEggType.MORE_TIME:
			Session.game.countdown.time_left = 20
			Session.game.show_effect("clock")
		SpecialEggType.FLAG:
			push_warning("SpecialEggType.FLAG does nothing")
	Session.game.spawn_special_egg()
	queue_free()
	return true


func _process(_delta: float) -> void:
	match special_type:
		SpecialEggType.FREEZE:
			disabled = Session.game.freezed_timer >= -3
		SpecialEggType.NO_GHOSTS:
			disabled = (get_tree().get_nodes_in_group("enemy").size() < 15) or (Session.game.freezed_timer >= 0)
		SpecialEggType.MORE_TIME:
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

class_name Egg extends Area2D


func eat() -> bool:
	Session.eggs += 1
	if Session.player._i_frames <= 0:
		Session.health += 1
	if (randi_range(1,10) == 1 and Session.eggs >= 32) or Session.eggs == 2:
		Session.game.spawn_ghost()
	if (Session.eggs == 100):
		for i in 20:
			Session.game.spawn_special_egg()
	Session.game.spawn_egg()
	queue_free()
	return true

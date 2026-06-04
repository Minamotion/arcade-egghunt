class_name GhostEnemy extends Area2D


@export_category("Physics")
@export var speed: int= 0


var _i_frames: int= 60
var _last_position: Vector2= global_position


@onready var poke_scene: PackedScene= preload("res://scenes/gameplay/ghost/poke/poke.tscn")


func respawn() -> void:
	var poke: Node2D= poke_scene.instantiate()
	poke.global_position = global_position
	get_parent().add_child(poke)
	queue_free()
	Session.game.spawn_ghost()


func _physics_process(delta: float) -> void:
	if Session.player is Player and (_i_frames <= 0 and Session.game.freezed_timer <= 0):
		_last_position = Session.player.global_position
		if (global_position.distance_to(_last_position) <= 48):
			speed = lerp(speed, 64, 0.1)
		else:
			speed = lerp(speed, 128, 0.01)
	else:
		speed = 0
	global_position -= (global_position.direction_to(_last_position) * -speed) * delta


func _process(_delta: float) -> void:
	if _i_frames >= 0 or Session.game.freezed_timer >= 0:
		visible = abs(_i_frames) %2 == 1
		_i_frames -= 1
	else:
		visible = true


func _on_body_entered(body: Node2D) -> void:
	if (_i_frames > 0 or Session.game.freezed_timer > 0):
		return
	if body is Player:
		if body.hurt():
			print("Player was hurt, respawning...")
			respawn()


func _on_area_entered(area: Area2D) -> void:
	if (_i_frames > 0 or Session.game.freezed_timer > 0):
		return
	if area is GhostEnemy:
		print("Multiple ghosts collided, respawning...\n")
		respawn()

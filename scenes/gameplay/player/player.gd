class_name Player extends CharacterBody2D


@onready var sprite = %Sprite
var face: String= "d"


@onready var snd_hurt = %Hurt
@onready var snd_earn = %Earn


@export_category("Physics")
@export var speed: float= 128


var _i_frames: int= 0


func _ready() -> void:
	Session.player = self


func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("game_left", "game_right", "game_up", "game_down")
	velocity = direction * (speed/2 if _i_frames > 0 else speed)
	move_and_slide()


func _process(_delta: float) -> void:
	var anim = "idle"
	if not velocity.is_zero_approx():
		anim = "move"
		if abs(velocity.x) > 0:
			face = "lr"
			sprite.flip_h = !(velocity.x > 0)
		elif abs(velocity.y) > 0:
			face = "d" if (velocity.y > 0) else "u"
	sprite.play(str(face,"_",anim))
	if _i_frames >= 0:
		visible = _i_frames%2==1
		_i_frames -= 1
	else:
		visible = true


func _on_egg_detector_detect_egg(egg: Node2D) -> void:
	if egg is Egg:
		if not egg.eat():
			return
		snd_earn.play()


func hurt() -> bool:
	if _i_frames > 0:
		return false
	Session.health -= 1
	if (Session.health <= 0):
		Session.game.show_game_over()
	_i_frames = 60
	snd_hurt.play()
	return true

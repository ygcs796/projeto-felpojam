extends CanvasLayer

@onready var lives_sprite: AnimatedSprite2D = get_node_or_null("Lives") as AnimatedSprite2D
var _current_lives: int = 5

func _ready() -> void:
	if lives_sprite == null:
		return

	_show_static(_current_lives)

func set_lives(value: int) -> void:
	if lives_sprite == null:
		return

	value = clamp(value, 0, 5)

	if value == _current_lives:
		_show_static(value)
		return

	if value == _current_lives - 1:
		_play_hit_animation_from(_current_lives)
		_current_lives = value
		return

	_current_lives = value
	_show_static(value)

func _play_hit_animation_from(from_lives: int) -> void:
	if lives_sprite == null:
		return
	if from_lives <= 0:
		return

	var anim := "life_%d" % from_lives
	lives_sprite.show()
	lives_sprite.play(anim)

func _show_static(lives: int) -> void:
	if lives_sprite == null:
		return

	lives_sprite.show()

	if lives <= 0:
		lives_sprite.play("life_1")
		var count := lives_sprite.sprite_frames.get_frame_count("life_1")
		lives_sprite.frame = max(count - 1, 0)
		lives_sprite.pause()
		return

	var anim := "life_%d" % lives
	lives_sprite.play(anim)
	lives_sprite.frame = 0
	lives_sprite.pause()

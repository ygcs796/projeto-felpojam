extends CanvasLayer

@onready var lives_sprite: AnimatedSprite2D = $Lives

var _prev_lives: int = -1

func bind(manager: Node) -> void:
	if manager.has_signal("lives_changed") and not manager.lives_changed.is_connected(_on_lives_changed):
		manager.lives_changed.connect(_on_lives_changed)

	if manager.has_signal("game_over") and not manager.game_over.is_connected(_on_game_over):
		manager.game_over.connect(_on_game_over)

	if "lives" in manager:
		_prev_lives = manager.lives
		_show_static(_prev_lives)

func _on_lives_changed(current: int) -> void:
	current = clamp(current, 0, 5)

	if _prev_lives == -1:
		_prev_lives = current
		_show_static(current)
		return

	# Perdeu vida
	if current < _prev_lives:
		_play_damage_anim(_prev_lives)
		_prev_lives = current
	else:
		_prev_lives = current
		_show_static(current)

func _play_damage_anim(from_lives: int) -> void:
	from_lives = clamp(from_lives, 1, 5)

	var anim_name := "life_%d" % from_lives
	if lives_sprite and lives_sprite.sprite_frames and lives_sprite.sprite_frames.has_animation(anim_name):
		lives_sprite.play(anim_name)
	else:
		_show_static(from_lives - 1)

func _show_static(lives: int) -> void:
	# Mostra o estado sem “derrubar outra vida”
	# Como você não tem life_0, quando lives = 0, só paramos no último frame da life_1.
	lives = clamp(lives, 0, 5)

	if not lives_sprite or not lives_sprite.sprite_frames:
		return

	if lives == 0:
		if lives_sprite.sprite_frames.has_animation("life_1"):
			lives_sprite.play("life_1")
			lives_sprite.stop()
			lives_sprite.frame = max(lives_sprite.sprite_frames.get_frame_count("life_1") - 1, 0)
		return

	var anim_name := "life_%d" % lives
	if lives_sprite.sprite_frames.has_animation(anim_name):
		# Para no primeiro frame
		lives_sprite.play(anim_name)
		lives_sprite.stop()
		lives_sprite.frame = 0

func _on_game_over() -> void:
	_show_static(0)

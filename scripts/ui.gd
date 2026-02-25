extends CanvasLayer

@onready var lives_label: Label = $LivesLabel

func bind(manager: Node) -> void:
	# Evita conectar duas vezes
	if manager.has_signal("lives_changed") and not manager.lives_changed.is_connected(_on_lives_changed):
		manager.lives_changed.connect(_on_lives_changed)

	if manager.has_signal("game_over") and not manager.game_over.is_connected(_on_game_over):
		manager.game_over.connect(_on_game_over)

	# Atualiza UI imediatamente caso o bind aconteça depois do reset
	if "lives" in manager:
		_on_lives_changed(manager.lives)

func _on_lives_changed(current: int) -> void:
	lives_label.text = "Vidas: %d" % current

func _on_game_over() -> void:
	lives_label.text = "GAME OVER"

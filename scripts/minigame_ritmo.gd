extends Node2D

signal lives_changed(current: int)
signal game_over()

@export var max_lives: int = 5
var lives: int = 0
var is_game_over: bool = false

# Spawn tuning:
@export var min_spawn_interval: float = 0.45
@export var max_spawn_interval: float = 1.20

@export var max_keys_on_screen: int = 2      # No máximo 2 setas ativas no total
@export var max_keys_per_lane: int = 2       # No máximo 2 por coluna

@onready var ui: CanvasLayer = $UI
@onready var spawn_timer: Timer = $SpawnTimer

@onready var lanes: Array = [
	$KeyListener1,
	$KeyListener2,
	$KeyListener3,
	$KeyListener4
]

func _ready() -> void:
	reset()
	if ui and ui.has_method("bind"):
		ui.bind(self)

	_schedule_next_spawn()

func reset() -> void:
	is_game_over = false
	lives = max_lives
	emit_signal("lives_changed", lives)

	for lane in lanes:
		if lane and lane.has_method("start_listener"):
			lane.start_listener()

func lose_life() -> void:
	if is_game_over:
		return

	lives -= 1
	if lives < 0:
		lives = 0

	emit_signal("lives_changed", lives)

	if lives <= 0:
		is_game_over = true
		emit_signal("game_over")
		_stop_minigame()

func _stop_minigame() -> void:
	if spawn_timer:
		spawn_timer.stop()

	for lane in lanes:
		if lane and lane.has_method("stop_listener"):
			lane.stop_listener()

func _on_spawn_timer_timeout() -> void:
	if is_game_over:
		return

	# No máximo 2 teclas na tela
	if get_tree().get_nodes_in_group("falling_keys").size() >= max_keys_on_screen:
		_schedule_next_spawn()
		return

	# Escolhe uma lane válida
	var candidates: Array = []
	for lane in lanes:
		if not lane:
			continue
		if lane.falling_keys_queue.size() < max_keys_per_lane:
			candidates.append(lane)

	# Se todas as lanes estão cheias, não spawna agora
	if candidates.is_empty():
		_schedule_next_spawn()
		return

	# Spawna em 1 lane aleatória
	var chosen_lane = candidates[randi() % candidates.size()]
	chosen_lane.spawn_falling_key()

	_schedule_next_spawn()

func _schedule_next_spawn() -> void:
	if not spawn_timer:
		return
	spawn_timer.one_shot = true
	spawn_timer.wait_time = randf_range(min_spawn_interval, max_spawn_interval)
	spawn_timer.start()

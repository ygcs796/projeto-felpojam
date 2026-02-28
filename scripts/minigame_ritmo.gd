extends Node2D

signal lives_changed(current: int)
signal game_over()

@export var max_lives: int = 5
var lives: int = 0
var is_game_over: bool = false

# Música
@export var music_part1: AudioStream
@export var music_part2: AudioStream

@onready var music: AudioStreamPlayer = $MusicPlayer
@onready var spawn_timer: Timer = $SpawnTimer
@onready var ui: CanvasLayer = $UI
@onready var player: Node = $PlayerDodge
@onready var enemy: Node = $"Jacaré"

# Queda das setas
@export var fall_speed_px_s: float = 100.0
@export var spawn_y: float = -100.0
@export var hit_y: float = 70.0

# Limites
@export var max_keys_on_screen: int = 6
@export var max_keys_per_lane: int = 2

@onready var lanes := {
	"left":  $KeyListener1,
	"down":  $KeyListener2,
	"up":    $KeyListener3,
	"right": $KeyListener4
}


# CHARTS (hit times em segundos)
var chart_part1 := {
	"left":  [0.650, 2.450, 4.888, 6.664, 8.882, 11.099, 14.211, 15.546, 17.763, 20.213, 22.651, 23.766, 26.657],
	"down":  [1.776, 3.553, 5.341, 8.440, 9.311, 11.540, 13.769, 14.861, 17.322, 20.875, 23.092, 24.869],
	"up":    [0.244, 4.005, 6.002, 7.105, 10.217, 11.993, 13.108, 15.999, 18.216, 19.098, 21.978, 25.530],
	"right": [1.335, 3.111, 4.435, 7.767, 9.764, 10.658, 12.446, 16.660, 18.646, 19.551, 21.316, 24.427, 26.204]
}

var chart_part2 := {
	"left":  [1.416, 2.113, 4.214, 6.118, 7.001, 8.371, 9.764, 12.156, 13.862, 15.232, 17.078, 18.599, 19.609, 21.618],
	"down":  [1.057, 1.765, 3.866, 6.641, 8.034, 8.719, 10.275, 13.015, 14.547, 16.242, 17.589, 18.262, 19.946],
	"up":    [0.522, 2.461, 3.332, 5.259, 7.686, 9.067, 10.786, 11.633, 14.211, 14.884, 16.579, 19.273, 20.283, 21.119],
	"right": [0.197, 2.810, 4.737, 5.596, 7.338, 9.416, 11.122, 12.504, 13.526, 15.732, 17.926, 18.936, 20.619]
}

# Eventos para spawn:
var events: Array[Dictionary] = []
var event_i: int = 0
var part: int = 1
var lead_time: float = 0.0

# Música entra depois do lead_time
var start_ms: int = 0
var music_started: bool = false
var phase_id: int = 0

func _ready() -> void:
	reset()
	if ui and ui.has_method("bind"):
		ui.bind(self)

	# Conecta signals dos listeners
	for lane in lanes.values():
		if not lane:
			continue
		if lane.pressed and not lane.pressed.is_connected(_on_key_listener_pressed):
			lane.pressed.connect(_on_key_listener_pressed)
		if lane.hit and not lane.hit.is_connected(_on_key_listener_hit):
			lane.hit.connect(_on_key_listener_hit)
		if lane.miss and not lane.miss.is_connected(_on_key_listener_miss):
			lane.miss.connect(_on_key_listener_miss)

	# Trocar da part1 para a part2 quando acabar
	if not music.finished.is_connected(_on_music_finished):
		music.finished.connect(_on_music_finished)

	_start_part1()

func reset() -> void:
	is_game_over = false
	lives = max_lives
	emit_signal("lives_changed", lives)

	for lane in lanes.values():
		if lane and lane.has_method("start_listener"):
			lane.start_listener()

func lose_life() -> void:
	if is_game_over:
		return
	lives = max(lives - 1, 0)
	emit_signal("lives_changed", lives)

	if lives <= 0:
		is_game_over = true
		emit_signal("game_over")
		_stop_minigame()

func _stop_minigame() -> void:
	spawn_timer.stop()
	music.stop()
	for lane in lanes.values():
		if lane and lane.has_method("stop_listener"):
			lane.stop_listener()

# Partes da música

func _start_part1() -> void:
	part = 1
	_prepare_events(chart_part1)
	_begin_phase(music_part1)

func _start_part2() -> void:
	part = 2
	_prepare_events(chart_part2)
	_begin_phase(music_part2)

func _begin_phase(stream: AudioStream) -> void:
	phase_id += 1
	var my_id := phase_id

	# Reseta timer interno
	start_ms = Time.get_ticks_msec()
	music_started = false

	# Para o que estava acontecendo
	spawn_timer.stop()
	music.stop()

	# Prepara música sem tocar
	music.stream = stream

	# Começa a spawnar as teclas
	_schedule_next_spawn()

	# Inicia música depois do lead_time
	_start_music_after_lead(my_id)

func _start_music_after_lead(my_id: int) -> void:
	call_deferred("_start_music_after_lead_async", my_id)

func _start_music_after_lead_async(my_id: int) -> void:
	await get_tree().create_timer(lead_time).timeout
	if is_game_over:
		return
	if my_id != phase_id:
		return
	music_started = true
	music.play()

func _on_music_finished() -> void:
	if is_game_over:
		return

	# Quando a música termina, avançar fase
	if part == 1:
		_start_part2()
	else:
		_stop_minigame()

# Beatmap -> eventos
func _prepare_events(chart: Dictionary) -> void:
	lead_time = max((hit_y - spawn_y) / fall_speed_px_s, 0.0)

	events.clear()
	event_i = 0

	for lane_name in chart.keys():
		var times: Array = chart[lane_name]
		for ht in times:
			var hit_time: float = float(ht)
			var spawn_time: float = hit_time - lead_time
			events.append({"t": spawn_time, "lane": lane_name})

	events.sort_custom(func(a, b): return float(a["t"]) < float(b["t"]))

# Spawn sincronizado
func _on_spawn_timer_timeout() -> void:
	if is_game_over:
		return
	_spawn_due()
	_schedule_next_spawn()

func _spawn_due() -> void:
	if event_i >= events.size():
		return

	if get_tree().get_nodes_in_group("falling_keys").size() >= max_keys_on_screen:
		return

	var t := _get_chart_time()

	while event_i < events.size():
		var e := events[event_i]
		var spawn_t: float = float(e["t"])
		if t < spawn_t:
			break

		var lane_name: String = e["lane"]
		var lane = lanes.get(lane_name)

		if lane and lane.falling_keys_queue.size() < max_keys_per_lane:
			lane.spawn_falling_key()

		event_i += 1

		if get_tree().get_nodes_in_group("falling_keys").size() >= max_keys_on_screen:
			break

func _schedule_next_spawn() -> void:
	if event_i >= events.size():
		spawn_timer.stop()
		return

	var t := _get_chart_time()
	var next_t: float = float(events[event_i]["t"])
	var wait: float = max(next_t - t, 0.001)

	spawn_timer.one_shot = true
	spawn_timer.wait_time = wait
	spawn_timer.start()

# Antes da música tocar: tempo interno (negativo, começando em -lead_time)
# Depois: tempo do áudio
func _get_chart_time() -> float:
	if music_started and music.playing:
		return _get_song_time()

	var elapsed := (Time.get_ticks_msec() - start_ms) / 1000.0
	return elapsed - lead_time

func _get_song_time() -> float:
	var t := music.get_playback_position()
	t += AudioServer.get_time_since_last_mix()
	t -= AudioServer.get_output_latency()
	return t

# Animações

func _on_key_listener_pressed(direction: String) -> void:
	if is_game_over:
		return
	if enemy and enemy.has_method("play_attack"):
		enemy.play_attack(direction)

func _on_key_listener_hit(direction: String) -> void:
	if is_game_over:
		return
	if player and player.has_method("play_dodge"):
		player.play_dodge(direction)

func _on_key_listener_miss(_direction: String) -> void:
	if is_game_over:
		return
	if player and player.has_method("play_damage"):
		player.play_damage()
	lose_life()

func debug_print_time(_direction: String) -> void:
	var t := 0.0
	if music_started and music.playing:
		t = _get_song_time()
	print("%.3f" % t)

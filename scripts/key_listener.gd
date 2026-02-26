extends Sprite2D

signal pressed(direction: String)
signal hit(direction: String)
signal miss(direction: String)

@onready var falling_keys: PackedScene = preload("res://scenes/falling_keys.tscn")

@export var key_name: String = ""
@export var hit_window: float = 15.0

var falling_keys_queue: Array = []
var active: bool = true

func _process(_delta: float) -> void:
	if not active:
		return

	# Miss automático: passou do ponto sem apertar
	if falling_keys_queue.size() > 0 and falling_keys_queue.front().has_passed:
		var missed = falling_keys_queue.pop_front()
		missed.queue_free()
		emit_signal("miss", _direction_from_frame())

	# Apertou o botão desta lane
	if Input.is_action_just_pressed(key_name):
		var dir := _direction_from_frame()
		emit_signal("pressed", dir)
		_handle_press(dir)

func _handle_press(dir: String) -> void:
	# >>> NOVO: apertou sem seta = NÃO PUNE (não perde vida)
	if falling_keys_queue.size() == 0:
		return

	var key_to_check = falling_keys_queue.pop_front()
	var distance: float = abs(float(key_to_check.pass_threshold) - float(key_to_check.global_position.y))
	key_to_check.queue_free()

	if distance > hit_window:
		# Erro de timing (aqui você decide se pune ou não)
		emit_signal("miss", dir)
	else:
		emit_signal("hit", dir)

func _direction_from_frame() -> String:
	match frame:
		0: return "left"
		1: return "down"
		2: return "up"
		3: return "right"
		_: return "right"

func spawn_falling_key() -> void:
	if not active:
		return

	var fk_instance = falling_keys.instantiate()
	get_tree().root.call_deferred("add_child", fk_instance)
	fk_instance.Setup(position.x, frame)
	falling_keys_queue.push_back(fk_instance)

func stop_listener() -> void:
	active = false
	for k in falling_keys_queue:
		if is_instance_valid(k):
			k.queue_free()
	falling_keys_queue.clear()

func start_listener() -> void:
	active = true

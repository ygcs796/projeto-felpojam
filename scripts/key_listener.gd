extends Sprite2D

@onready var falling_keys: PackedScene = preload("res://scenes/falling_keys.tscn")
@onready var manager: Node = get_parent()

@export var key_name: String = ""
@export var hit_window: float = 15.0

var falling_keys_queue: Array = []
var active: bool = true

func _process(delta: float) -> void:
	if not active:
		return

	# Miss por passar do ponto
	if falling_keys_queue.size() > 0 and falling_keys_queue.front().has_passed:
		var missed = falling_keys_queue.pop_front()
		missed.queue_free()
		_report_miss()

	# Verifica se apertou o botão
	if Input.is_action_just_pressed(key_name):
		_handle_press()

func _handle_press() -> void:
	if falling_keys_queue.size() == 0:
		_report_miss()
		return

	var key_to_check = falling_keys_queue.pop_front()
	var distance = abs(key_to_check.pass_threshold - key_to_check.global_position.y)
	key_to_check.queue_free()

	if distance > hit_window:
		_report_miss()

func _report_miss() -> void:
	if manager and manager.has_method("lose_life"):
		manager.lose_life()

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

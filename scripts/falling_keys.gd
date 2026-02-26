extends Sprite2D

@export var fall_speed: float = 100
var init_y_pos: float = -100.0
var has_passed: bool = false
var pass_threshold: float = 70.0

@onready var timer: Timer = $Timer

func _init() -> void:
	set_process(false)

func _process(delta: float) -> void:
	global_position.y += fall_speed * delta

	if position.y > pass_threshold and not timer.is_stopped():
		timer.stop()
		has_passed = true

func Setup(target_x: float, target_frame: int) -> void:
	global_position = Vector2(target_x, init_y_pos)
	frame = target_frame
	has_passed = false
	add_to_group("falling_keys")
	set_process(true)

func _on_destroy_timer_timeout() -> void:
	queue_free()

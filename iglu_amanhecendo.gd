extends Node2D

@export var next_scene_path: String = "res://scenes/polo_sul.tscn"
@export var dawn_time_seconds: float = 5.0
@export var transition_close_anim: StringName = &"apagar"

@onready var anim: AnimationPlayer = $transicao_circulo/AnimationPlayer

var can_advance := false
var is_transitioning := false

func _ready() -> void:
	await get_tree().create_timer(dawn_time_seconds).timeout
	can_advance = true

func _input(event: InputEvent) -> void:
	if is_transitioning:
		return
	if not can_advance:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_transition_to(next_scene_path)

func _transition_to(scene_path: String) -> void:
	is_transitioning = true

	if anim and anim.has_animation(transition_close_anim):
		anim.play(transition_close_anim)
		await anim.animation_finished
	else:
		pass

	get_tree().change_scene_to_file(scene_path)

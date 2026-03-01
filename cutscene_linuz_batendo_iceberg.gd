extends Node2D

@export var wait_seconds := 1.2
@export var return_scene := "res://scenes/minigame_surf.tscn"

@onready var transicao: AnimationPlayer = $transicao_circulo/AnimationPlayer

var can_click := false
var transitioning := false

func _ready() -> void:
	get_tree().paused = false
	can_click = false
	await get_tree().create_timer(wait_seconds).timeout
	can_click = true

func _input(event: InputEvent) -> void:
	if transitioning or not can_click:
		return

	if (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT) \
	or (event is InputEventScreenTouch and event.pressed):
		_return_to_minigame()

func _return_to_minigame() -> void:
	transitioning = true

	# Começa nadando ao voltar para o minigame
	get_tree().set_meta("player_state", "swim")

	if transicao and transicao.has_animation("apagar"):
		var anim_res := transicao.get_animation("apagar")
		var duration := anim_res.length if anim_res else 0.35

		transicao.play("apagar")
		await get_tree().create_timer(duration).timeout

	get_tree().change_scene_to_file(return_scene)

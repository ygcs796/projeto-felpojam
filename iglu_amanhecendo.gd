extends Node2D

@export var next_scene_path: String = "res://polo_sul.tscn"

# Quanto tempo o "iglu amanhecendo" precisa antes de permitir avançar (ajuste)
@export var dawn_time_seconds: float = 2.0

# Nome da animação de fechar a transição (a do círculo fechando)
@export var transition_close_anim: StringName = &"apagar"

@onready var anim: AnimationPlayer = $transicao_circulo/AnimationPlayer

var can_advance := false
var is_transitioning := false

func _ready() -> void:
	# (Opcional) garante que a transição está no estado inicial
	# Se você tiver uma animação tipo "acender", pode tocar aqui.
	# anim.play("acender")

	# Espera o amanhecer terminar (simples)
	await get_tree().create_timer(dawn_time_seconds).timeout
	can_advance = true

func _unhandled_input(event: InputEvent) -> void:
	if is_transitioning:
		return
	if not can_advance:
		return

	# Space / Enter normalmente são ui_accept
	if event.is_action_pressed("ui_accept"):
		_transition_to(next_scene_path)

func _transition_to(scene_path: String) -> void:
	is_transitioning = true

	# Toca a animação de fechar (círculo fechando)
	if anim and anim.has_animation(transition_close_anim):
		anim.play(transition_close_anim)
		await anim.animation_finished
	else:
		# Se não achar a animação, não trava: troca direto
		push_warning("Transição: AnimationPlayer ou animação não encontrada: " + str(transition_close_anim))

	get_tree().change_scene_to_file(scene_path)

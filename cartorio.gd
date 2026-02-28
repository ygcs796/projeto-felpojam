extends Node2D

@export var wait_seconds := 2.0
@export var target_scene := "res://cenario_santa_catarina.tscn"
@export var target_spawn_name := "spawn_cartorio"

@export var transition_scene: PackedScene = preload("res://transicao_circulo.tscn")

const anim_apaga: StringName = &"apagar"

var can_click := false
var transitioning := false

func _ready() -> void:
	# Espera alguns segundos antes de permitir sair
	await get_tree().create_timer(wait_seconds).timeout
	can_click = true

func _unhandled_input(event: InputEvent) -> void:
	if transitioning or not can_click:
		return

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_exit_to_beach()

func _exit_to_beach() -> void:
	transitioning = true

	# Marca no SceneTree onde o player deve nascer na próxima cena
	get_tree().set_meta("spawn_point", target_spawn_name)

	# Instancia a transição por cima
	var t := transition_scene.instantiate() as CanvasLayer
	add_child(t)

	var anim := t.get_node_or_null("AnimationPlayer") as AnimationPlayer
	if anim and anim.has_animation(anim_apaga):
		anim.play(anim_apaga)
		await anim.animation_finished

	# Troca de cena
	get_tree().change_scene_to_file(target_scene)

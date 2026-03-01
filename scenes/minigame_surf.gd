extends Node2D

@onready var contador = $contador/Label
@onready var anim: AnimationPlayer = $transicao_circulo/AnimationPlayer
@onready var linuz = $Linuz

var came_back_swimming := false

@export var after_return_duration := 10.0

func _ready() -> void:
	get_tree().paused = true

	if get_tree().has_meta("player_state"):
		var st := String(get_tree().get_meta("player_state"))
		get_tree().remove_meta("player_state")

		if st == "swim" and linuz and linuz.has_method("set_state_swim"):
			linuz.set_state_swim()
			came_back_swimming = true

	anim.play("aparecer")
	await anim.animation_finished

	contador.text = ""
	comecar_contador()

func comecar_contador() -> void:
	contador.text = "3"
	await get_tree().create_timer(1.0).timeout
	contador.text = "2"
	await get_tree().create_timer(1.0).timeout
	contador.text = "1"
	await get_tree().create_timer(1.0).timeout
	contador.text = "VAI!"
	await get_tree().create_timer(0.5).timeout

	contador.text = ""
	get_tree().paused = false

	if came_back_swimming:
		_start_end_sequence()

func _start_end_sequence() -> void:
	await get_tree().create_timer(after_return_duration).timeout

	get_tree().paused = true

	if anim and anim.has_animation("apagar"):
		anim.play("apagar")
		await anim.animation_finished

	get_tree().paused = false
	get_tree().change_scene_to_file("res://cutscene_encontro.tscn")

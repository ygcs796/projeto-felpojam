extends Node2D

@onready var contador = $contador/Label
@onready var anim: AnimationPlayer = $transicao_circulo/AnimationPlayer
@onready var linuz = $Linuz

func _ready() -> void:
	get_tree().paused = true

	# Se veio da cutscene do iceberg, começa nadando
	if get_tree().has_meta("player_state"):
		var st := String(get_tree().get_meta("player_state"))
		get_tree().remove_meta("player_state")

		if st == "swim" and linuz and linuz.has_method("set_state_swim"):
			linuz.set_state_swim()

	anim.play("aparecer")
	await anim.animation_finished

	contador.text = ""
	comecar_contador()

func comecar_contador():
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

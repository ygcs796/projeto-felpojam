extends Node2D

@onready var contador = $contador/Label
@onready var anim = $transicao_circulo/AnimationPlayer

func _ready() -> void:
	get_tree().paused = true
	anim.play("aparecer")
	await anim.animation_finished
	contador.text = ""
	comecar_contador()
	
func comecar_contador():
	#get_tree().paused = true
	
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

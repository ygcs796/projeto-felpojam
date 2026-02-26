extends Node2D

@onready var player = $Player
@onready var adversario = $adversario
@onready var bola = $bola_volei

#@onready var posicao_inicial_bola_x = bola.position.x
#@onready var posicao_inicial_bola_y = bola.position.y


func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	var diferenca_pos = (bola.position.x - adversario.position.x)
	var velocidade = diferenca_pos / (delta * 500)
	adversario.position.x += velocidade * delta
	pass
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_R:
			print("R apertado")
			bola.position.x = 40
			bola.position.y = 56
			print("processo feito")

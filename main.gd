extends Node2D

@onready var player = $Player
@onready var adversario = $adversario

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	var diferenca_pos = (player.position.x - adversario.position.x)
	var velocidade = diferenca_pos / (delta * 100)
	adversario.position.x += velocidade * delta
	pass

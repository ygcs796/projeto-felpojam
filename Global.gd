extends Node

var velocidade_jogo = 100.0

func _process(delta: float) -> void:
	
	velocidade_jogo += 2 * delta

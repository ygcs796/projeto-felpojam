extends Node

# variável que vai ser usada no minigame do sul
var velocidade_jogo = 130.0

func _process(delta: float) -> void:
	
	velocidade_jogo += 2 * delta

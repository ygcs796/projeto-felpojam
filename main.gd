extends Node2D

var pontos_player = 0
var pontos_adversario = 0
@onready var label_contagem = $Contagem/LabelContagem
@onready var bola = $bola_volei
@onready var placar = $placar/Label
@onready var player = $Player
@onready var adversario = $adversario

func _ready() -> void:
	label_contagem.text = ""
	comecar_contador()
	pass
	
func _on_zona_player_body_entered(body: Node2D) -> void:
	if body.name == "bola_volei":
		pontos_adversario += 1
		atualizar_placar()
		resetar_partida_bola_do_adversario()
	
	pass # Replace with function body.

func _on_zona_adversario_body_entered(body: Node2D) -> void:
	if body.name == "bola_volei":
		pontos_player += 1
		atualizar_placar()
		resetar_partida_bola_do_player()
	pass # Replace with function body.
	
func atualizar_placar():
	placar.text = "Placar: " + str(pontos_player) + " - " + str(pontos_adversario)
	pass

func resetar_partida_bola_do_player():
	bola.quem_joga = "player"
	bola.deve_resetar = true
	comecar_contador()
	pass
	
func resetar_partida_bola_do_adversario():
	bola.quem_joga = "adversario"
	bola.deve_resetar = true
	comecar_contador()
	pass
#	
func comecar_contador():
	get_tree().paused = true
	label_contagem.show()
	
	label_contagem.text = "3"
	await get_tree().create_timer(1.0).timeout
	
	label_contagem.text = "2"
	await get_tree().create_timer(1.0).timeout
	
	label_contagem.text = "1"
	await get_tree().create_timer(1.0).timeout
	
	label_contagem.text = "VAI"
	await get_tree().create_timer(0.5).timeout
	
	label_contagem.text = ""
	get_tree().paused = false
	
	pass

extends Node2D

var score = 0
var vidas = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	atualizar_placar()
	pass # Replace with function body.

func registrar_galinha(nova_galinha):
	nova_galinha.coletada.connect(_on_galinha_coletada)

func _on_galinha_coletada(tipo):
	
	# verificando o tipo e fazendo as mudanças necessárias
	if tipo == "branca":
		score += 1
		verificar_vitoria()
	else:
		vidas -= 1
		verificar_gameover()
	
	# atualizando a HUD do placar
	atualizar_placar()

func verificar_vitoria():
	if score >= 5:
		# colocar a tela de vitoria aqui
		#get_tree().change_scene_to_file()
		pass

func verificar_gameover():
	if vidas <= 0:
		# colocar a tela de game over aqui
		#get_tree().change_scene_to_file()
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func atualizar_placar():
	$CanvasLayer/score_label.text = "Score: " + str(score) + " | " + "Vidas: " + str(vidas)

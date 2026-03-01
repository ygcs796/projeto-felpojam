extends Node2D

@export var max_good := 5 # Quantas certas até ganhar 
@export var max_bad := 5  # Quantas erradas até perder 

var score := 0
var erros := 0

@onready var hud: CanvasLayer = $CanvasLayer

func _ready() -> void:
	_atualizar_hud_inicial()

func registrar_galinha(nova_galinha) -> void:
	nova_galinha.coletada.connect(_on_galinha_coletada)

# Brancas são as galinhas certas e as de outras cores são as erradas
func _on_galinha_coletada(tipo: String) -> void:
	if tipo == "branca":
		score = clamp(score + 1, 0, max_good)
		if hud.has_method("set_good"):
			hud.set_good(score)
		verificar_vitoria()
	else:
		erros = clamp(erros + 1, 0, max_bad)
		if hud.has_method("set_bad"):
			hud.set_bad(erros)
		verificar_gameover()

	atualizar_placar()

func verificar_vitoria() -> void:
	if score >= max_good:
		pass

func verificar_gameover() -> void:
	if erros >= max_bad:
		pass

func atualizar_placar() -> void:
	if hud.has_method("update_score_text"):
		hud.update_score_text(score, erros, max_bad)

func _atualizar_hud_inicial() -> void:
	score = 0
	erros = 0

	if hud.has_method("_show_static_good"):
		hud._show_static_good(1)
	elif has_node("CanvasLayer/BarGood"):
		$CanvasLayer/BarGood.play("good_1")
		$CanvasLayer/BarGood.frame = 0
		$CanvasLayer/BarGood.pause()
	if has_node("CanvasLayer/BarBad"):
		$CanvasLayer/BarBad.hide()

	atualizar_placar()

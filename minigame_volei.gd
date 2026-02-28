extends Node2D

var pontos_player = 0
var pontos_adversario = 0
@onready var label_contagem = $Contagem/LabelContagem
@onready var bola = $bola_volei
@onready var placar = $placar/Label
@onready var player = $Player
@onready var adversario = $adversario
@onready var placar_vermelho = $placar/vermelho
@onready var placar_azul = $placar/azul
@onready var apito = $apito
@onready var music_player = $musica

var musica_inicio = preload("res://assets/sfx/musica/1inicioreggaeton.ogg")
var musica_loop = preload("res://assets/sfx/musica/2loopreggaeton.ogg")

func _ready() -> void:
	music_player.finished.connect(_on_musica_terminou)
	music_player.stream = musica_inicio
	music_player.play()
	
	label_contagem.text = ""
	comecar_contador()
		
func _on_zona_player_body_entered(body: Node2D) -> void:
	if body.name == "bola_volei":
		pontos_adversario += 1
		atualizar_placar()
		verificar_resultado_adversario()

func _on_zona_adversario_body_entered(body: Node2D) -> void:
	if body.name == "bola_volei":
		pontos_player += 1
		atualizar_placar()
		verificar_resultado_player()
	
func atualizar_placar():
	#placar.text = "Placar: " + str(pontos_player) + " - " + str(pontos_adversario)
	placar_azul.play(str(pontos_player))
	placar_vermelho.play(str(pontos_adversario))

func resetar_partida_bola_do_player():
	bola.quem_joga = "player"
	bola.deve_resetar = true
	comecar_contador()
	
func resetar_partida_bola_do_adversario():
	bola.quem_joga = "adversario"
	bola.deve_resetar = true
	comecar_contador()
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
	apito.play()
	await get_tree().create_timer(0.5).timeout
	
	label_contagem.text = ""
	get_tree().paused = false
	
func verificar_resultado_player():
	
	if pontos_player == 5: #vitória
		get_tree().paused = true
		$Vitoria.visible = true
	else:
		resetar_partida_bola_do_player()
		
func verificar_resultado_adversario():
	
	if pontos_adversario == 5: #derrota
		get_tree().paused = true
		$Derrota.visible = true
		
	else:
		resetar_partida_bola_do_adversario()

func _on_musica_terminou():
	if music_player.stream == musica_inicio:
		
		music_player.stream = musica_loop
		music_player.play()

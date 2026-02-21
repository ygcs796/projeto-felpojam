extends Area2D

signal coletada(cor)
@export var cor_da_galinha: String = "azul"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# fazendo a galinha andar da direita para a esquerda
	position.x -= Global.velocidade_jogo * delta
	
	if position.x <= -20:
		print("Galinha excluída")
		queue_free()
	pass

func hit():
	coletada.emit(cor_da_galinha)
	print("Galinha atingidda")
	queue_free()

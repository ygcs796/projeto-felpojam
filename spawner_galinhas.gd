extends Node2D

@export var galinhas: Array[PackedScene]

@onready var positions = [$Pos_up, $Pos_mid, $Pos_down]

func _ready() -> void:
	spawn_proximo_item()
	pass
	
func spawn_proximo_item():
	
	var galinha_escolhida = galinhas.pick_random()
	var posicao_escolhida = positions.pick_random()
	var nova_galinha = galinha_escolhida.instantiate()
	nova_galinha.position = posicao_escolhida.position
	add_child(nova_galinha)
	
	if get_parent().has_method("_on_galinha_coletada"):
		nova_galinha.coletada.connect(get_parent()._on_galinha_coletada)

	nova_galinha.tree_exited.connect(spawn_proximo_item)

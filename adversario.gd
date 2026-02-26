extends CharacterBody2D

@onready var bola = get_parent().get_node("bola_volei")

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	move_and_collide(delta * velocity)
	pass
	
func _process(delta: float) -> void:
	var diferenca_pos = (bola.position.x - position.x)
	var velocidade = diferenca_pos / (delta * 1000)
	position.x += velocidade * delta
	pass

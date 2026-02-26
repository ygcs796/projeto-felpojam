extends CharacterBody2D

@export var velocidade_max = 50
@export var velocidade_pulo = -125
@export var sensibilidade = 0.1
@export var altura_gatilho = 100

@onready var bola = get_parent().get_node("bola_volei")

func _physics_process(delta: float) -> void:
	move_and_collide(delta * velocity)
	
	var diferenca_x = bola.global_position.x - global_position.x
	
	# aplicando velocidade com um suavizador (sensibilidade)
	velocity.x = diferenca_x * (velocidade_max * sensibilidade)
	
	# limitador de velocidade (pra não ficar infinita)
	velocity.x = clamp(velocity.x, -velocidade_max, velocidade_max)
	
	if is_on_floor() and bola.global_position.y < altura_gatilho:
		
		if abs(diferenca_x) < 50:
			velocity.y = velocidade_pulo
			
	if not is_on_floor():
		
		velocity += get_gravity() * delta
		
	move_and_slide()

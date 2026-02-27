extends CharacterBody2D

@export var velocidade_max = 30
@export var velocidade_pulo = -125
@export var sensibilidade = 0.1
@export var altura_gatilho = 100
@export var intervalo_pulo = 0.5

@onready var bola = get_parent().get_node("bola_volei")

var pode_pular = true

func _physics_process(delta: float) -> void:
	move_and_collide(delta * velocity)
	
	var diferenca_x = bola.global_position.x - global_position.x
	
	# aplicando velocidade com um suavizador (sensibilidade)
	velocity.x = diferenca_x * (velocidade_max * sensibilidade)
	
	# limitador de velocidade (pra não ficar infinita)
	velocity.x = clamp(velocity.x, -velocidade_max, velocidade_max)
	
	if is_on_floor() and pode_pular: 
		
		if bola.global_position.y < altura_gatilho and abs(diferenca_x) < 50:
			pular()
			
	if not is_on_floor():
		
		velocity += get_gravity() * delta
		
	move_and_slide()

func atualizar_animacao():
	if not is_on_floor():
		$AnimatedSprite2D.play("pulando")
	elif velocity.x != 0:
		$AnimatedSprite2D.play("andando_esquerda")
	else:
		$AnimatedSprite2D.play("parado")
	
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = false
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = true
	

func pular():
	
	velocity.y = velocidade_pulo
	pode_pular = false
	await get_tree().create_timer(intervalo_pulo).timeout
	
	pode_pular = true

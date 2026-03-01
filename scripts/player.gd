extends CharacterBody2D

# Configurações
var tile_size = 16  # O tamanho do passo
var move_speed = 0.28 # Tempo em segundos para dar um passo

# Variáveis de controle
var is_moving = false # Trava o input quando an
var input_direction = Vector2.ZERO
var previous_direction = input_direction
var primeira_perna = true # variável para deixar a animação mais realista
@onready var ray = $RayCast2D
@onready var anim = $AnimatedSprite2D

func _physics_process(_delta):
	# Se já estiver andando, não aceita novos comandos
	if is_moving:
		return

	input_direction = Vector2.ZERO
	if Input.is_key_pressed(KEY_W):
		input_direction = Vector2.UP
		previous_direction = input_direction
	elif Input.is_key_pressed(KEY_S):
		input_direction = Vector2.DOWN
		previous_direction = input_direction
	elif Input.is_key_pressed(KEY_A):
		input_direction = Vector2.LEFT
		previous_direction = input_direction
	elif Input.is_key_pressed(KEY_D):
		input_direction = Vector2.RIGHT
		previous_direction = input_direction
	
	
	# Se houve algum input, tenta mover
	if input_direction != Vector2.ZERO:
		move(input_direction, previous_direction)
	else:
		# Se parou, toca animação de Idle (parado)
		update_animation(input_direction, previous_direction)

func move(dir, prev_dir):
	# 1. Atualiza a animação para a direção que vai andar
	update_animation(dir, prev_dir)
	
	# 2. Verifica colisão com RayCast antes de andar
	# Aponta o raio para onde queremos ir (ex: 160px para a direita)
	ray.target_position = dir * (tile_size + 2)
	ray.force_raycast_update()
	
	if ray.is_colliding():
		return
	
	# 3. Inicia o movimento (Tween)
	
	# calcuando a posição para onde ele deve ir
	var target_position = position + (dir * tile_size)
	
	is_moving = true
	
	var tween = create_tween()
	# Move da posição atual para (posição atual + 160px na direção)
	# Trans.TRANS_SINE deixa o movimento mais suave no início e fim
	tween.tween_property(self, "position", target_position, move_speed)#.set_trans(Tween.TRANS_SINE)
	
	# Quando o tween terminar, libera para andar de novo
	tween.finished.connect(func(): is_moving = false)

func update_animation(dir, prev_dir):
	# é necessário eu declarar aqui
	# para que a animação não fique
	# invertida para sempre
	
	# Exemplo simples de controle de animação
	if dir == Vector2.UP:
		if primeira_perna:
			anim.play("walk_up_1")
			primeira_perna = false
		else:
			anim.play("walk_up_2")
			primeira_perna = true

	elif dir == Vector2.DOWN:
		if primeira_perna:
			anim.play("walk_down_1")
			primeira_perna = false
		else:
			anim.play("walk_down_2")
			primeira_perna = true
	elif dir == Vector2.LEFT:
		# invertendo uma animação que eu 
		# já tenho
		anim.flip_h = true
		if primeira_perna:
			anim.play("walk_right_1")
			primeira_perna = false
		else:
			anim.play("walk_right_2")
			primeira_perna = true
		#sprite.flip_h = false
	elif dir == Vector2.RIGHT:
		# mudando o valor da variável 
		# para não deixar a animação invertida
		# pra sempre
		anim.flip_h = false
		if primeira_perna:
			anim.play("walk_right_1")
			primeira_perna = false
		else:
			anim.play("walk_right_2")
			primeira_perna = true
	else:
		idle_animations(prev_dir)
			
func idle_animations(prev_dir):
	if prev_dir == Vector2.UP:
		anim.play("idle_up")
	elif prev_dir == Vector2.DOWN:
		anim.play("idle_down")
	elif prev_dir == Vector2.RIGHT:
		# mudando o valor da variável 
		# para não deixar a animação invertida
		# pra sempre
		anim.flip_h = false
		anim.play("idle_right")
	elif prev_dir == Vector2.LEFT:
		anim.flip_h = true
		anim.play("idle_right")
	else: #animação padrão
		anim.play("idle_down")

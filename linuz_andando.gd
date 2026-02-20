extends CharacterBody2D

# Configurações
@onready var ray = $colisao_paredes
var tile_size = 50  # O tamanho do seu passo (conforme você pediu)
var move_speed = 0.15 # Tempo em segundos para dar um passo (quanto menor, mais rápido)
var linuz_position = 2 # isso quer dizer que o linuz vai começar no meio do mapa

# Variáveis de controle
var is_moving = false # Trava o input enquanto o boneco anda
var input_direction = Vector2.ZERO

func _physics_process(delta):
	
	# Se já estiver andando, não aceita novos comandos
	if is_moving:
		return

	# Verifica as teclas (configure "ui_up", "ui_down", etc. no mapa de entrada)
	input_direction = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		linuz_position -= 1
		input_direction = Vector2.UP
	elif Input.is_action_pressed("ui_down"):
		linuz_position += 1
		input_direction = Vector2.DOWN
	
	if input_direction != Vector2.ZERO:
		move(input_direction)

func move(dir):
	
	# 2. Verifica colisão com RayCast antes de andar
	# Aponta o raio para onde queremos ir (ex: 160px para a direita)
	ray.target_position = dir * tile_size
	ray.force_raycast_update() # Força a atualização imediata do raio
	
	if ray.is_colliding():
		## Se o raio bateu em algo, não anda!
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

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.has_method("hit"):
		area.hit()
	pass # Replace with function body.

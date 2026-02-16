extends CharacterBody2D

var tile_size = 16  # Tamanho do seu grid
var is_moving = false

func _physics_process(_delta):
	if is_moving:
		return

	var input_direction = Vector2.ZERO
	
	# Captura a direção (Apenas uma por vez, estilo retrô)
	if Input.is_action_pressed("ui_right"):
		input_direction = Vector2.RIGHT
	elif Input.is_action_pressed("ui_left"):
		input_direction = Vector2.LEFT
	elif Input.is_action_pressed("ui_down"):
		input_direction = Vector2.DOWN
	elif Input.is_action_pressed("ui_up"):
		input_direction = Vector2.UP

	if input_direction != Vector2.ZERO:
		run_animation(input_direction)

func run_animation(direction):
		
	# mudando o valor do flip para que eu não
	# tenha a animação invertida o tempo todo
	$AnimatedSprite2D.flip_h = false
	
	if direction == Vector2.UP:	
		$AnimatedSprite2D.play("walk_up")
	elif direction == Vector2.DOWN:
		$AnimatedSprite2D.play("walk_down")
	elif direction == Vector2.RIGHT:
		$AnimatedSprite2D.play("walk_right")
	elif direction == Vector2.LEFT:
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("walk_right")
	
	move_to_grid(direction)

func move_to_grid(dir):
	is_moving = true
	
	# Calcula o destino exato no grid
	var target_position = position + (dir * tile_size)
	
	# Cria a animação de deslize
	var tween = create_tween()
	tween.tween_property(self, "position", target_position, 0.2) # 0.2 segundos para mover
	
	# Quando terminar de mover, permite novo input
	tween.finished.connect(func(): is_moving = false)

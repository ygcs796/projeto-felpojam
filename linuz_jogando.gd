extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -250.0
const forca_cabecada = 0.25

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	atualizar_animacao()
	
func atualizar_animacao():
	
	if not is_on_floor():
		$AnimatedSprite2D.play("pulando")
		
	elif velocity.x != 0:
		$AnimatedSprite2D.play("andando_direita")
	
	else:
		$AnimatedSprite2D.play("parado")
		
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	

func _on_cabeca_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		body.linear_velocity = Vector2.ZERO
		var direcao = Vector2(2, -2)
		body.apply_central_impulse(direcao * forca_cabecada)
		
func ganhou():
	$AnimatedSprite2D.play("vitoria")
	pass
	
func perdeu():
	$AnimatedSprite2D.play("derrota")
	caiu()
	
func caiu():
	$AnimatedSprite2D.visible = false
	$caido.visible = true
	$caido.play("caido")

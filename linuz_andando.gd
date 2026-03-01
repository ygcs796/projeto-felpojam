extends CharacterBody2D

@onready var ray = $colisao_paredes
var tile_size = 50  
var move_speed = 0.15
var linuz_position = 2

# Variáveis de controle
var is_moving = false
var input_direction = Vector2.ZERO

func _physics_process(delta):
	
	# Se já estiver andando, não aceita novos comandos
	if is_moving:
		return

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
	
	ray.target_position = dir * tile_size
	ray.force_raycast_update()
	
	if ray.is_colliding():
		return

	var target_position = position + (dir * tile_size)
	
	is_moving = true
	
	var tween = create_tween()
	tween.tween_property(self, "position", target_position, move_speed)
	tween.finished.connect(func(): is_moving = false)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.has_method("hit"):
		area.hit()
	pass

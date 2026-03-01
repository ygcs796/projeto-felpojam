extends CharacterBody2D

# Configurações
var tile_size = 16  
var move_speed = 0.3 #

# Variáveis de controle
var is_moving = false 
var input_direction = Vector2.ZERO
var previous_direction = input_direction
var primeira_perna = true 

@onready var ray = $RayCast2D
@onready var anim = $AnimatedSprite2D

func _physics_process(_delta):
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
	
	if input_direction != Vector2.ZERO:
		move(input_direction, previous_direction)
	else:
		update_animation(input_direction, previous_direction)

func move(dir, prev_dir):
	update_animation(dir, prev_dir)
	
	ray.target_position = dir * (tile_size + 2)
	ray.force_raycast_update()
	#
	if ray.is_colliding():
		return
	
	var target_position = position + (dir * tile_size)
	
	is_moving = true
	
	var tween = create_tween()
	tween.tween_property(self, "position", target_position, move_speed)
	tween.finished.connect(func(): is_moving = false)

func update_animation(dir, prev_dir):
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
		anim.flip_h = true
		if primeira_perna:
			anim.play("walk_right_1")
			primeira_perna = false
		else:
			anim.play("walk_right_2")
			primeira_perna = true
	elif dir == Vector2.RIGHT:
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
		anim.flip_h = false
		anim.play("idle_right")
	elif prev_dir == Vector2.LEFT:
		anim.flip_h = true
		anim.play("idle_right")
	else:
		anim.play("idle_down")

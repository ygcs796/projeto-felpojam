extends CharacterBody2D

@export var tiles_to_walk := 2
@export var tile_size := 16 * transform.get_scale().x
@export var speed := 40.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var start_x: float
var dir := 1

func _ready() -> void:
	start_x = global_position.x
	anim.play("walk")

func _physics_process(_delta: float) -> void:
	var max_x := start_x + tiles_to_walk * tile_size
	var min_x := start_x

	# Muda direção de andar quando chega no limite
	if global_position.x >= max_x:
		dir = -1
	elif global_position.x <= min_x:
		dir = 1

	# Muda a direção da animação
	anim.flip_h = dir > 0

	velocity = Vector2(dir * speed, 0)
	move_and_slide()

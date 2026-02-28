extends CharacterBody2D

@export var tiles_to_walk := 2
@export var tile_size := 16 * transform.get_scale().x
@export var speed := 40.0

@export var flee_distance := 48.0
@export var flee_speed_multiplier := 1.25

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: Node2D = get_tree().get_first_node_in_group("player") as Node2D

var start_x: float
var dir := 1
var is_fleeing := false

func _ready() -> void:
	start_x = global_position.x
	anim.play("walk")

func _physics_process(_delta: float) -> void:
	if player:
		var dist := global_position.distance_to(player.global_position)

		if dist <= flee_distance:
			is_fleeing = true

		var safe_dist := flee_distance + (tiles_to_walk * tile_size)
		if is_fleeing and dist >= safe_dist:
			is_fleeing = false

	if is_fleeing and player:
		# Foge pro lado oposto ao player
		dir = -1 if global_position.x < player.global_position.x else 1

		anim.flip_h = dir > 0
		velocity = Vector2(dir * speed * flee_speed_multiplier, 0)
		move_and_slide()
		return

	var max_x := start_x + tiles_to_walk * tile_size
	var min_x := start_x

	if global_position.x >= max_x:
		dir = -1
	elif global_position.x <= min_x:
		dir = 1

	anim.flip_h = dir > 0

	velocity = Vector2(dir * speed, 0)
	move_and_slide()

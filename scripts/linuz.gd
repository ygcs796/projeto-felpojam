extends CharacterBody2D

@export var speed := 120.0
@export var min_x := 10.0 # Posição mínima do X
@export var max_x := 230.0 # Posição máxima do X
@export var min_y := 10.0 # Posição mínima do X
@export var max_y := 150.0 # Posição máxima do X
@export var max_lives := 3

var lives := 3
enum PlayerState {surf, swim}
var state = PlayerState.surf

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var lives_label: Label = $"../UI/Lives"

func _ready() -> void:
	# Sempre “surfando”
	animation.play("surf")
	lives = max_lives
	_update_lives_ui()
	
func _update_lives_ui() -> void:
	if lives_label:
		lives_label.text = "Vidas: %d" % lives

func _physics_process(delta: float) -> void:
	# Input de movimento
	var dx := Input.get_axis("ui_left", "ui_right")
	var dy := Input.get_axis("ui_up", "ui_down")
	var direction := Vector2(dx, dy)

	# Movimento
	velocity = direction.normalized() * speed if direction != Vector2.ZERO else Vector2.ZERO
	move_and_slide()

	# Limita o X e o Y
	global_position.x = clamp(global_position.x, min_x, max_x)
	global_position.y = clamp(global_position.y, min_y, max_y)

func _on_collision_area_entered(area: Area2D) -> void:
	lives -= 1
	_update_lives_ui()
	area.queue_free()
	
	if area.is_in_group("iceberg"):
		_start_swimming()
		return

	if lives <= 0:
		_game_over()
		
func _start_swimming():
	state = PlayerState.swim
	$AnimatedSprite2D.play("swim")
		
func _game_over() -> void:
	get_tree().reload_current_scene()

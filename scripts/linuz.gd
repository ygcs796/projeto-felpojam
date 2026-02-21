extends CharacterBody2D

@export var speed := 120.0
@export var min_y := 10.0 # Posição mínima do Y
@export var max_y := 150.0 # Posição máxima do Y
@export var max_lives := 3

var lives := 3

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var lives_label: Label = $"../UI/Lives"

func _ready() -> void:
	# Sempre “andando” pra dar sensação de avanço constante
	animation.play("walk_right_1")
	lives = max_lives
	_update_lives_ui()
	
func _update_lives_ui() -> void:
	if lives_label:
		lives_label.text = "Vidas: %d" % lives

func _physics_process(delta: float) -> void:
	var dy := Input.get_axis("ui_up", "ui_down")
	velocity = Vector2(0, dy * speed)
	move_and_slide()

	# Trava o X e limita o Y dentro da faixa
	global_position.x = 10
	global_position.y = clamp(global_position.y, min_y, max_y)

func _on_collision_area_entered(area: Area2D) -> void:
	var invulnerable := false
	
	# Evita perder várias vidas encostando por 1 segundo
	if invulnerable:
		return

	lives -= 1
	_update_lives_ui()
	area.queue_free()

	invulnerable = true
	await get_tree().create_timer(1.0).timeout
	invulnerable = false

	if lives <= 0:
		_game_over()
		
func _game_over() -> void:
	get_tree().reload_current_scene()

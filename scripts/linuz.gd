extends CharacterBody2D

signal lives_changed(current: int)

@export var speed := 120.0
@export var min_x := 10.0
@export var max_x := 230.0
@export var min_y := 10.0
@export var max_y := 150.0
@export var max_lives := 5

# Anti-hit duplo
@export var damage_cooldown := 0.25
var _can_take_damage := true

var lives := 5

enum PlayerState { surf, swim }
var state = PlayerState.surf

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var ui: CanvasLayer = $"../UI"
@onready var damage_timer: Timer = Timer.new()

func _ready() -> void:
	animation.play("surf")
	lives = max_lives

	# Timer anti-hit duplo
	damage_timer.one_shot = true
	damage_timer.wait_time = damage_cooldown
	add_child(damage_timer)
	damage_timer.timeout.connect(func(): _can_take_damage = true)

	# Conecta UI
	if ui and ui.has_method("set_lives"):
		lives_changed.connect(ui.set_lives)

	emit_signal("lives_changed", lives)

func _physics_process(_delta: float) -> void:
	var dx := Input.get_axis("ui_left", "ui_right")
	var dy := Input.get_axis("ui_up", "ui_down")
	var direction := Vector2(dx, dy)

	velocity = direction.normalized() * speed if direction != Vector2.ZERO else Vector2.ZERO
	move_and_slide()

	global_position.x = clamp(global_position.x, min_x, max_x)
	global_position.y = clamp(global_position.y, min_y, max_y)

func _on_collision_area_entered(area: Area2D) -> void:

	if not _can_take_damage:
		return

	_can_take_damage = false
	damage_timer.start()

	_take_damage()

	area.queue_free()

	if area.is_in_group("iceberg"):
		_start_swimming()
		return

	if lives <= 0:
		_game_over()


func _take_damage() -> void:

	lives = max(lives - 1, 0)
	emit_signal("lives_changed", lives)

	# 🔴 animação de dano (1 frame)
	animation.play("damage_surf")

	# Espera um pouco para o jogador perceber o dano
	await get_tree().create_timer(0.15).timeout

	# Volta para animação correta
	if state == PlayerState.swim:
		animation.play("swim")
	else:
		animation.play("surf")


func _start_swimming() -> void:
	state = PlayerState.swim
	animation.play("swim")


func _game_over() -> void:
	await get_tree().create_timer(0.35).timeout
	get_tree().reload_current_scene()

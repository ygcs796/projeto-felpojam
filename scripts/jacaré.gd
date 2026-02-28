extends CharacterBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
var attacking: bool = false

func _ready() -> void:
	play_idle()

func play_idle() -> void:
	if animation:
		animation.play("idle")

func play_attack(direction: String) -> void:
	if not animation or attacking:
		return

	attacking = true

	var enemy_dir := _opposite_dir(direction)
	var animation_name := "attack_%s" % enemy_dir

	if animation.sprite_frames and animation.sprite_frames.has_animation(animation_name):
		animation.play(animation_name)
	elif animation.sprite_frames and animation.sprite_frames.has_animation("attack"):
		animation.play("attack")
	else:
		animation.play("idle")

	await animation.animation_finished
	attacking = false
	play_idle()

func _opposite_dir(d: String) -> String:
	match d:
		"left": return "left"
		"right": return "right"
		"up": return "down"
		"down": return "up"
		_: return "down"

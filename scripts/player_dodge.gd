extends CharacterBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
var locked: bool = false

func _ready() -> void:
	play_idle()

func play_idle() -> void:
	if animation:
		animation.play("idle")

func play_damage() -> void:
	if not animation or locked:
		return
	locked = true
	animation.play("damage")
	await animation.animation_finished
	locked = false
	play_idle()

func play_dodge(direction: String) -> void:
	if not animation or locked:
		return
	locked = true

	var anim_name := "dodge_%s" % direction
	if animation.sprite_frames and animation.sprite_frames.has_animation(anim_name):
		animation.play(anim_name)
	else:
		animation.play("idle")

	await animation.animation_finished
	locked = false
	play_idle()

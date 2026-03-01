extends Node2D

@onready var anim: AnimationPlayer = $transicao_circulo/AnimationPlayer
var transitioning := false

func _ready() -> void:
	anim.play("aparecer")

func _input(event: InputEvent) -> void:
	if transitioning:
		return

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		transitioning = true

		anim.play("apagar")
		await anim.animation_finished

		get_tree().change_scene_to_file("res://cenario_santa_catarina.tscn")

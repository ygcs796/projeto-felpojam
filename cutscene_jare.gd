extends Node2D

@onready var anim = $transicao_circulo/AnimationPlayer

func _ready():
	anim.play("aparecer")

func _input(event: InputEvent) -> void:
	
	if Input.is_key_pressed(KEY_ENTER):
		
		anim.play("apagar")
		await anim.animation_finished
		get_tree().change_scene_to_file("res://scenes/minigame_ritmo.tscn")

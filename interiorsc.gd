extends Node2D

@onready var transicao = $transicao_circulo/AnimationPlayer

func _on_colisao_shekira_area_entered(area: Area2D) -> void:
	transicao.play("apagar")
	await transicao.animation_finished
	get_tree().change_scene_to_file("res://minigame_sul.tscn")
	pass # Replace with function body.

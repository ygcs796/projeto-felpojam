extends Node2D

@onready var anim = $transicao_circulo/AnimationPlayer

func _on_area_2d_area_entered(area: Area2D) -> void:
	anim.play("apagar")
	await anim.animation_finished
	get_tree().change_scene_to_file()
	
	pass # Replace with function body.

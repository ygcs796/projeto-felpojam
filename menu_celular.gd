extends Control


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://iglu_amanhecendo.tscn")


func _on_credit_pressed() -> void:
	get_tree().change_scene_to_file("res://creditos.tscn")

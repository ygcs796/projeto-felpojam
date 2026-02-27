extends Control


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://iglu_amanhecendo.tscn")

func _on_settings_pressed() -> void:
	#get_tree().change_scene_to_file("res://creditos.tscn")
	pass # Replace with function body.


func _on_controles_pressed() -> void:
	get_tree().change_scene_to_file("res://controles.tscn")
	pass # Replace with function body.


func _on_creditos_pressed() -> void:
	get_tree().change_scene_to_file("res://creditos.tscn")
	pass # Replace with function body.

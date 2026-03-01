extends Control

func _on_restart_button_down() -> void:
	#get_tree().change_scene_to_file()
	get_tree().reload_current_scene()

func _on_quit_button_down() -> void:
	get_tree().quit()

extends Node

var menu

func _ready():
	menu = preload("res://menu_celular.tscn").instantiate()
	get_tree().root.add_child(menu)

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		menu.toggle_menu()
		
func _input(event):
	if event.is_action_pressed("pause"):
		menu.toggle_menu()

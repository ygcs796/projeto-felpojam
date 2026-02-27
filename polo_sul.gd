extends Node2D

@onready var camera = $Player/Camera2D
@onready var mapa = $cenario_polo_sul/agua
var tile_size = 16

func _ready() -> void:
	
	var limites_mapa = mapa.get_used_rect()
	
	camera.limit_left = limites_mapa.position.x * tile_size
	camera.limit_top = limites_mapa.position.y * tile_size
	camera.limit_bottom = limites_mapa.end.y * tile_size
	camera.limit_right = limites_mapa.end.x * tile_size
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	get_tree().change_scene_to_file("res://scenes/minigame_surf.tscn")
	pass # Replace with function body.

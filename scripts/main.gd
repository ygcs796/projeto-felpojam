extends Node2D

#@onready var tilemap = $Cenario # Arraste seu TileMapLayer aqui

func _ready():
	#var map_limits = tilemap.get_used_rect()
	var cell_size = 16
	var camera = $Player/Camera2D
	
	#camera.limit_left = map_limits.position.x * cell_size
	#camera.limit_right = map_limits.end.x * cell_size
	#camera.limit_top = map_limits.position.y * cell_size
	#camera.limit_bottom = map_limits.end.y * cell_size

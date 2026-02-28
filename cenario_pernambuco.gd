extends Node2D

@onready var mapa = $chao
@onready var camera = $Player/Camera2D
@onready var anim = $transicao_circulo/AnimationPlayer

func _ready():
	var tile_size = 16
	var limites_mapa = mapa.get_used_rect()
	
	camera.limit_left = limites_mapa.position.x * tile_size
	camera.limit_right = limites_mapa.end.x * tile_size
	camera.limit_top = limites_mapa.position.y * tile_size
	camera.limit_bottom = limites_mapa.end.y * tile_size

func _on_colisao_jacare_area_entered(area: Area2D) -> void:
	anim.play("apagar")
	await anim.animation_finished
	get_tree().change_scene_to_file("res://cutscene_jare.tscn")

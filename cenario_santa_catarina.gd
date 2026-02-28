extends Node2D

@onready var transicao: AnimationPlayer = $transicao_circulo/AnimationPlayer

@onready var spawn_cartorio: Marker2D = $spawn_cartorio

@onready var colisao_cartorio: Area2D = $colisao_cartorio
@onready var colisao_interior: Area2D = $colisao_interior

var transitioning := false
var teleporting := false

var came_from_cartorio := false


func _ready() -> void:
	if get_tree().has_meta("spawn_point"):
		var spawn_name := String(get_tree().get_meta("spawn_point"))
		get_tree().remove_meta("spawn_point")

		var spawn := get_node_or_null(spawn_name)
		var player := get_node_or_null("Player")
		if spawn and player:
			player.global_position = spawn.global_position

		# Se voltou do cartório
		if spawn_name == "spawn_cartorio":
			came_from_cartorio = true

			# Não pode entrar no cartório novamente
			if colisao_cartorio:
				colisao_cartorio.monitoring = false
				colisao_cartorio.monitorable = false


func _on_colisao_rua_area_entered(area: Area2D) -> void:
	if teleporting or transitioning:
		return

	var player := area.get_parent()
	if player == null or player.name != "Player":
		return

	teleporting = true

	player.global_position = spawn_cartorio.global_position

	await get_tree().process_frame
	teleporting = false


func _on_colisao_cartorio_area_entered(area: Area2D) -> void:
	if transitioning:
		return

	if came_from_cartorio:
		return

	var player := area.get_parent()
	if player == null or player.name != "Player":
		return

	transitioning = true

	transicao.play("apagar")
	await transicao.animation_finished

	get_tree().change_scene_to_file("res://cartorio.tscn")


func _on_colisao_interior_area_entered(area: Area2D) -> void:
	if transitioning:
		return

	# 🔒 BLOQUEADO até passar pelo cartório
	if not came_from_cartorio:
		return

	var player := area.get_parent()
	if player == null or player.name != "Player":
		return

	transitioning = true

	transicao.play("apagar")
	await transicao.animation_finished

	get_tree().change_scene_to_file("res://interiorsc.tscn")

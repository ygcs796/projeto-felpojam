extends Node2D

@export var shekira_dialogue: DialogueResource
@export var balloon_scene: PackedScene

@onready var transicao: AnimationPlayer = $transicao_circulo/AnimationPlayer
@onready var spawn_cartorio: Marker2D = $spawn_cartorio
@onready var colisao_cartorio: Area2D = $colisao_cartorio
@onready var colisao_interior: Area2D = $colisao_interior

var transitioning := false
var teleporting := false
var came_from_cartorio := false

var shekira_2_done := false


func _ready() -> void:
	var dialogue_to_play := ""

	if get_tree().has_meta("play_dialogue"):
		dialogue_to_play = String(get_tree().get_meta("play_dialogue"))
		get_tree().remove_meta("play_dialogue")

	if get_tree().has_meta("spawn_point"):
		var spawn_name := String(get_tree().get_meta("spawn_point"))
		get_tree().remove_meta("spawn_point")

		var spawn := get_node_or_null(spawn_name)
		var player := get_node_or_null("Player")
		if spawn and player:
			player.global_position = spawn.global_position

		# Se voltou do cartório, não pode entrar no cartório novamente
		if spawn_name == "spawn_cartorio":
			came_from_cartorio = true
			if colisao_cartorio:
				colisao_cartorio.monitoring = false
				colisao_cartorio.monitorable = false

	await get_tree().process_frame
	if dialogue_to_play != "":
		_play_dialogue(dialogue_to_play)
	else:
		_play_dialogue("shekira_1")


func _play_dialogue(title: String) -> void:
	if shekira_dialogue == null or balloon_scene == null:
		push_error("Faltou configurar shekira_dialogue ou balloon_scene no Inspector.")
		return

	var dialogue := balloon_scene.instantiate()
	get_tree().current_scene.add_child(dialogue)
	dialogue.start(shekira_dialogue, title)


func _on_colisao_rua_area_entered(area: Area2D) -> void:
	if teleporting or transitioning:
		return

	var player := area.get_parent()
	if player == null or player.name != "Player":
		return

	teleporting = true
	player.global_position = spawn_cartorio.global_position

	if !shekira_2_done:
		shekira_2_done = true
		_play_dialogue("shekira_2")

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
	if not came_from_cartorio:
		return

	var player := area.get_parent()
	if player == null or player.name != "Player":
		return

	transitioning = true
	transicao.play("apagar")
	await transicao.animation_finished
	get_tree().change_scene_to_file("res://interiorsc.tscn")

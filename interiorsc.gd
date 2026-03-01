extends Node2D

@onready var transicao: AnimationPlayer = $transicao_circulo/AnimationPlayer
@onready var colisao_shekira: Area2D = $colisao_shekira

@export var shekira_dialogue: DialogueResource
@export var balloon_scene: PackedScene
@export var first_title: String = "shekira_interior_1"
@export var after_minigame_title: String = "shekira_interior_2"
@export var next_scene_after_after_minigame: String = "res://cutscene_chegando_rio.tscn"
@export var transition_close_anim: StringName = &"apagar"

var transitioning := false

func _ready() -> void:
	if GameState.has_flag("minigame_sul_done"):
		_disable_minigame_area()

	await get_tree().process_frame

	var title := first_title
	if get_tree().has_meta("play_dialogue"):
		title = String(get_tree().get_meta("play_dialogue"))
		get_tree().remove_meta("play_dialogue")

	await _play_dialogue_and_wait(title)

	if title == after_minigame_title:
		await _transition_to(next_scene_after_after_minigame)


func _disable_minigame_area() -> void:
	if colisao_shekira:
		colisao_shekira.monitoring = false
		colisao_shekira.monitorable = false


func _play_dialogue_and_wait(title: String) -> void:
	if shekira_dialogue == null or balloon_scene == null:
		push_error("Configure shekira_dialogue e balloon_scene no Inspector.")
		return

	var balloon := balloon_scene.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(shekira_dialogue, title)
	await balloon.dialogue_finished


func _on_colisao_shekira_area_entered(area: Area2D) -> void:
	if GameState.has_flag("minigame_sul_done"):
		return

	if transitioning:
		return

	var player := area.get_parent()
	if player == null or player.name != "Player":
		return

	transitioning = true

	transicao.play(transition_close_anim)
	await transicao.animation_finished

	get_tree().change_scene_to_file("res://minigame_sul.tscn")


func _transition_to(scene_path: String) -> void:
	if transitioning:
		return
	transitioning = true

	if transicao and transicao.has_animation(transition_close_anim):
		transicao.play(transition_close_anim)
		await transicao.animation_finished

	get_tree().change_scene_to_file(scene_path)

extends Node2D

@export var polo_scene_path: String = "res://scenes/polo_sul.tscn"

# Intro depois de dar play
@export var dawn_time_seconds: float = 5.0
@export var transition_close_anim: StringName = &"apagar"

@export var dialogue_return: DialogueResource
@export var dialogue_title: String = "cama_1"
@export var cutscene_balloon: PackedScene
@export var loop_anim_name: StringName = &"amanhecer_loop"

@onready var anim: AnimationPlayer = $transicao_circulo/AnimationPlayer
@onready var iglu_anim: AnimatedSprite2D = $AnimatedSprite2D

var is_transitioning := false

func _ready() -> void:
	if !GameState.has_flag("iglu_intro_done"):
		GameState.set_flag("iglu_intro_done", true)
		await get_tree().create_timer(dawn_time_seconds).timeout
		await _transition_to(polo_scene_path)
		return

	if GameState.has_flag("polo_intro_done") and !GameState.has_flag("iglu_return_done"):
		_play_loop_animation()

		var b = DialogueManager.show_dialogue_balloon_scene(
			cutscene_balloon,
			dialogue_return,
			dialogue_title
		)
		await b.dialogue_finished

		GameState.set_flag("iglu_return_done", true)
		await _transition_to(polo_scene_path)
		return

	await _transition_to(polo_scene_path)


func _play_loop_animation() -> void:
	if iglu_anim == null:
		return

	if iglu_anim.sprite_frames != null and iglu_anim.sprite_frames.has_animation(String(loop_anim_name)):
		iglu_anim.play(loop_anim_name)
	else:
		if iglu_anim.sprite_frames != null and iglu_anim.sprite_frames.get_animation_names().size() > 0:
			iglu_anim.play(iglu_anim.sprite_frames.get_animation_names()[0])


func _transition_to(scene_path: String) -> void:
	if is_transitioning:
		return
	is_transitioning = true

	if anim and anim.has_animation(transition_close_anim):
		anim.play(transition_close_anim)
		await anim.animation_finished

	get_tree().change_scene_to_file(scene_path)

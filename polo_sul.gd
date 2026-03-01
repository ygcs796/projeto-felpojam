extends Node2D

@onready var camera = $Player/Camera2D
@onready var mapa = $cenario_polo_sul/agua
@onready var anim = $transicao_circulo/AnimationPlayer
var tile_size = 16

@export var dialogue_polo_1: DialogueResource
@export var cutscene_balloon: PackedScene

var cutscene_done := false

func _ready() -> void:
	get_tree().paused = false

	var limites_mapa = mapa.get_used_rect()
	camera.limit_left = limites_mapa.position.x * tile_size
	camera.limit_top = limites_mapa.position.y * tile_size
	camera.limit_bottom = limites_mapa.end.y * tile_size
	camera.limit_right = limites_mapa.end.x * tile_size

	if !GameState.has_flag("polo_intro_done"):
		_play_intro()
		GameState.set_flag("polo_intro_done", true)

func _play_intro() -> void:
	var cutscene = DialogueManager.show_dialogue_balloon_scene(
	cutscene_balloon,
	dialogue_polo_1,
	"polo_1"
)

	await cutscene.dialogue_finished

	cutscene_done = true

	anim.play("apagar")
	await anim.animation_finished
	get_tree().change_scene_to_file("res://iglu_amanhecendo.tscn")


func _on_area_2d_area_entered(area: Area2D) -> void:
	if !GameState.has_flag("polo_intro_done"):
		return

	if !GameState.has_flag("iglu_return_done"):
		return

	anim.play("apagar")
	get_tree().paused = true
	await anim.animation_finished
	get_tree().change_scene_to_file("res://scenes/minigame_surf.tscn")

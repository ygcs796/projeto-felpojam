extends Node2D

@export var dialogue_resource: DialogueResource
@export var dialogue_title: String = "start"
@export var balloon_scene: PackedScene
@onready var trigger: Area2D = $colisao_capivara

var _already_played := false
var _is_playing := false

func _ready() -> void:
	if trigger and not trigger.area_entered.is_connected(_on_trigger_area_entered):
		trigger.area_entered.connect(_on_trigger_area_entered)

func _on_trigger_area_entered(area: Area2D) -> void:
	if _already_played or _is_playing:
		return

	var parent := area.get_parent()
	var is_player := false

	if parent != null and parent.name == "Player":
		is_player = true
	elif area.is_in_group("player") or (parent != null and parent.is_in_group("player")):
		is_player = true

	if not is_player:
		return

	_play_dialogue_once()

func _play_dialogue_once() -> void:
	if _already_played or _is_playing:
		return

	if dialogue_resource == null or balloon_scene == null:
		push_error("NPC: configure dialogue_resource e balloon_scene no Inspector.")
		return

	_is_playing = true
	_already_played = true

	var b := balloon_scene.instantiate()
	get_tree().current_scene.add_child(b)

	b.start(dialogue_resource, dialogue_title)
	await b.dialogue_finished
	_is_playing = false

	if trigger:
		trigger.monitoring = false
		trigger.monitorable = false

extends CanvasLayer
signal dialogue_finished

@export var dialogue_resource: DialogueResource
@export var start_from_title: String = ""
@export var auto_start: bool = false
@export var next_action: StringName = &"ui_accept"
@export var skip_action: StringName = &"ui_cancel"
@export var hide_character_name: bool = false
@export var hide_portraits: bool = false

@export var cutscene_auto: bool = false
@export var seconds_per_character: float = 0.03
@export var min_hold_time: float = 0.9
@export var max_hold_time: float = 4.0

var temporary_game_states: Array = []
var is_waiting_for_input: bool = false
var _frames_cache: Dictionary = {}

var dialogue_line: DialogueLine:
	set(value):
		if value:
			dialogue_line = value
			apply_dialogue_line()
		else:
			var player = get_tree().get_first_node_in_group("player")
			if player:
				player.dialogue_open = false

			emit_signal("dialogue_finished")

			if owner == null:
				queue_free()
			else:
				hide()
	get:
		return dialogue_line


@onready var balloon: Control = %Balloon
@onready var portrait_player: AnimatedSprite2D = %PortraitPlayer
@onready var portrait_npc: AnimatedSprite2D = %PortraitNpc
@onready var character_label: RichTextLabel = %CharacterLabel
@onready var dialogue_label: DialogueLabel = %DialogueLabel
@onready var responses_menu: DialogueResponsesMenu = %ResponsesMenu


func _ready() -> void:
	balloon.hide()

	if responses_menu.next_action.is_empty():
		responses_menu.next_action = next_action

	if auto_start:
		if not is_instance_valid(dialogue_resource):
			assert(false, DMConstants.get_error_message(DMConstants.ERR_MISSING_RESOURCE_FOR_AUTOSTART))
		start()

func start(with_dialogue_resource: DialogueResource = null, title: String = "", extra_game_states: Array = []) -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.dialogue_open = true

	temporary_game_states = [self] + extra_game_states
	is_waiting_for_input = false

	if is_instance_valid(with_dialogue_resource):
		dialogue_resource = with_dialogue_resource

	if not title.is_empty():
		start_from_title = title

	dialogue_line = await dialogue_resource.get_next_dialogue_line(start_from_title, temporary_game_states)
	show()


func apply_dialogue_line() -> void:
	is_waiting_for_input = false
	balloon.focus_mode = Control.FOCUS_ALL
	balloon.grab_focus()

	character_label.visible = (not hide_character_name) and (not dialogue_line.character.is_empty())
	character_label.text = tr(dialogue_line.character, "dialogue")

	portrait_player.visible = not hide_portraits
	portrait_npc.visible = not hide_portraits
	if not hide_portraits:
		_set_portrait_for(dialogue_line.character)

	dialogue_label.hide()
	dialogue_label.dialogue_line = dialogue_line

	responses_menu.hide()
	responses_menu.responses = dialogue_line.responses

	balloon.show()

	_stop_talk(portrait_player)
	_stop_talk(portrait_npc)

	dialogue_label.show()
	if not dialogue_line.text.is_empty():
		var speaker: AnimatedSprite2D = _get_speaker_sprite(dialogue_line.character)
		_start_talk(speaker)
		dialogue_label.type_out()
		await dialogue_label.finished_typing
		_stop_talk(speaker)

	if cutscene_auto:
		responses_menu.hide()

		var dialogue = clamp(dialogue_line.text.length() * seconds_per_character, min_hold_time, max_hold_time)
		if dialogue_line.time != "":
			dialogue = dialogue_line.text.length() * seconds_per_character if dialogue_line.time == "auto" else dialogue_line.time.to_float()

		await get_tree().create_timer(dialogue).timeout
		next(dialogue_line.next_id)
		return

	if dialogue_line.responses.size() > 0:
		balloon.focus_mode = Control.FOCUS_NONE
		responses_menu.show()

	elif dialogue_line.time != "":
		var t2: float = dialogue_line.text.length() * 0.02 if dialogue_line.time == "auto" else dialogue_line.time.to_float()
		await get_tree().create_timer(t2).timeout
		next(dialogue_line.next_id)

	else:
		is_waiting_for_input = true
		balloon.focus_mode = Control.FOCUS_ALL
		balloon.grab_focus()

# Função para decidir quem está falando
func _get_speaker_sprite(character_name: String) -> AnimatedSprite2D:
	return portrait_player if character_name == "Linuz" else portrait_npc
	
func _stop_talk(portrait: AnimatedSprite2D) -> void:
	if not is_instance_valid(portrait): return
	portrait.stop()
	portrait.frame = 0

func _start_talk(portrait: AnimatedSprite2D) -> void:
	if not is_instance_valid(portrait): return
	portrait.play("talk")

func _set_portrait_for(character_name: String) -> void:
	var frames_path: String = "res://assets/characters/%s/portrait.tres" % character_name
	var frames: SpriteFrames = null

	if _frames_cache.has(frames_path):
		frames = _frames_cache[frames_path]

	elif ResourceLoader.exists(frames_path):
		frames = load(frames_path) as SpriteFrames
		_frames_cache[frames_path] = frames

	portrait_npc.sprite_frames = frames

	if frames and frames.has_animation("talk"):
		portrait_npc.play("talk")
	else:
		portrait_npc.stop()
		portrait_npc.frame = 0


func next(next_id: String) -> void:
	dialogue_line = await dialogue_resource.get_next_dialogue_line(next_id, temporary_game_states)


func _on_balloon_gui_input(event: InputEvent) -> void:
	if cutscene_auto:
		return
		
	if dialogue_label.is_typing:

		var mouse_click: bool = (
			event is InputEventMouseButton
			and event.button_index == MOUSE_BUTTON_LEFT
			and event.is_pressed()
		)

		var skip_pressed: bool = event.is_action_pressed(skip_action)

		if mouse_click or skip_pressed:
			get_viewport().set_input_as_handled()
			dialogue_label.skip_typing()
			return

	if not is_waiting_for_input:
		return

	if dialogue_line.responses.size() > 0:
		return

	get_viewport().set_input_as_handled()

	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		next(dialogue_line.next_id)

	elif event.is_action_pressed(next_action) and get_viewport().gui_get_focus_owner() == balloon:
		next(dialogue_line.next_id)


func _on_responses_menu_response_selected(response: DialogueResponse) -> void:
	next(response.next_id)

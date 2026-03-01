extends Control

@export var dialogue_resource: DialogueResource
@export var start_from_title: String = ""
@export var auto_start: bool = false
@export var next_action: StringName = &"ui_accept"
@export var skip_action: StringName = &"ui_cancel"

var temporary_game_states: Array = []
var is_waiting_for_input := false
var dialogue_line: DialogueLine:
	set(value):
		if value:
			dialogue_line = value
			apply_dialogue_line()
		else:
			if owner == null:
				queue_free()
			else:
				hide()
	get:
		return dialogue_line

@onready var text_label: RichTextLabel = $MarginContainer/RichTextLabel

func _ready() -> void:
	hide()
	if auto_start:
		start()

func start(with_dialogue_resource: DialogueResource = null, title: String = "", extra_game_states: Array = []) -> void:
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

	text_label.clear()
	text_label.append_text(dialogue_line.text)

	if dialogue_line.time != "":
		var t: float = dialogue_line.text.length() * 0.02 if dialogue_line.time == "auto" else dialogue_line.time.to_float()
		await get_tree().create_timer(t).timeout
		next(dialogue_line.next_id)
	else:
		is_waiting_for_input = true

func next(next_id: String) -> void:
	dialogue_line = await dialogue_resource.get_next_dialogue_line(next_id, temporary_game_states)

func _unhandled_input(event: InputEvent) -> void:
	if !visible:
		return
	if !is_waiting_for_input:
		return

	var mouse_click = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()
	if mouse_click or event.is_action_pressed(next_action):
		get_viewport().set_input_as_handled()
		next(dialogue_line.next_id)

	if event.is_action_pressed(skip_action):
		get_viewport().set_input_as_handled()
		dialogue_line = null

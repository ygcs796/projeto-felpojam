extends Area2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

@export var join_party_on_end: bool = false
@export var join_party_only_if_start_is: String = ""

@onready var label: Label = $Label

func _ready() -> void:
	label.visible = false

func _on_area_entered(area: Area2D) -> void:
	if area.name == "ActionableFinder":
		label.visible = true

func _on_area_exited(area: Area2D) -> void:
	if area.name == "ActionableFinder":
		label.visible = false

func action() -> void:
	label.visible = false

	if join_party_on_end:
		if join_party_only_if_start_is == "" or join_party_only_if_start_is == dialogue_start:
			var npc := get_parent()
			if npc != null and npc.has_method("join_party"):
				PartyManager.register_pending(npc)

	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)

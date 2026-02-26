extends Area2D

@export var dialogue_resource: DialogueResource # Arquivo de diálogo que vai ser usado
@export var dialogue_start: String = "start" # Onde o diálogo começa

@onready var label: Label = $Label # Texto para interagir

func _ready() -> void:
	label.visible = false
	
# Mostra o texto quando o player se aproxima
func _on_area_entered(area: Area2D) -> void:
	if area.name == "ActionableFinder":
		label.visible = true

# O texto some quando o player se afasta
func _on_area_exited(area: Area2D) -> void:
	if area.name == "ActionableFinder":
		label.visible = false

# Função chamada quando o player interage com esse objeto
func action() -> void:
	label.visible = false
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start) 

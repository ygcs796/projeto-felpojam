extends Control

@onready var text: RichTextLabel = $MarginContainer/RichTextLabel

func set_text(s: String) -> void:
	text.clear()
	text.append_text(s)

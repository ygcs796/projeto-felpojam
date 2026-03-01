extends Node

var flags: Dictionary = {}

func has_flag(key: String) -> bool:
	return flags.has(key) and flags[key] == true

func set_flag(key: String, value: bool = true) -> void:
	flags[key] = value

extends Node2D

@onready var transicao: CanvasLayer = $transicao_circulo
@onready var anim: AnimationPlayer = $transicao_circulo/AnimationPlayer

var transitioning := false

func _ready() -> void:
	transicao.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if transitioning:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		transitioning = true
		await _do_transition()
		get_tree().change_scene_to_file("res://end.tscn")


func _do_transition() -> void:
	transicao.visible = true

	var anim_name := "apagar"
	if not anim.has_animation(anim_name):
		var list := anim.get_animation_list()
		if list.size() == 0:
			await get_tree().create_timer(0.1).timeout
			return
		anim_name = list[0]

	anim.stop()
	anim.play(anim_name)

	while anim.is_playing():
		await get_tree().process_frame

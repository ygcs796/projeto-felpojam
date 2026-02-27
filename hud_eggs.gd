extends CanvasLayer

@onready var bar_good: AnimatedSprite2D = get_node_or_null("BarGood") as AnimatedSprite2D
@onready var bar_bad: AnimatedSprite2D = get_node_or_null("BarBad") as AnimatedSprite2D

func _ready() -> void:
	if bar_good == null:
		push_error("HUD: não achei BarGood (AnimatedSprite2D). Confira o nome/caminho.")
	if bar_bad == null:
		push_error("HUD: não achei BarBad (AnimatedSprite2D). Confira o nome/caminho.")

	# Estados iniciais
	if bar_good:
		bar_good.show()
		_show_static_good(1) # Começa no good_1
	if bar_bad:
		bar_bad.hide() # Só aparece ao errar

func set_good(value: int) -> void:
	if bar_good == null:
		return
	value = clamp(value, 1, 5)
	var anim := "good_%d" % value
	bar_good.show()
	bar_good.play(anim) # Toca animação

func set_bad(value: int) -> void:
	if bar_bad == null:
		return

	value = clamp(value, 0, 5)

	if value <= 0:
		bar_bad.hide()
		return

	bar_bad.show()
	var anim := "bad_%d" % value
	bar_bad.play(anim) # Toca animação
	
func _show_static_good(value: int) -> void:
	var anim := "good_%d" % value
	bar_good.play(anim)
	bar_good.frame = 0
	bar_good.pause()

extends TileMapLayer

@export var scroll_speed := 140.0
@export var tile_width_px := 16.0

func _process(delta: float) -> void:
	# Move o cenário para baixo
	position.y += scroll_speed * delta

	# Mantém o offset sempre dentro do tamanho do tile para o padrão repetir
	position.y = fmod(position.y, tile_width_px)

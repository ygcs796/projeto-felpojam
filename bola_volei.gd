extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func impulso_na_bola(direcao: Vector2, forca: float):
	# aplicando impulso "peteleco
	apply_central_impulse(direcao * (forca * 10))

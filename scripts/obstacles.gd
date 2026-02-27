extends Area2D

@export var speed := 200.0

func _process(delta):
	position.y += speed * delta
	if position.y > 200:
		queue_free()

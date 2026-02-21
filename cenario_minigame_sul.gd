extends CharacterBody2D

@onready var bg = $background

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if bg.position.x < -240:
		bg.position.x = 0
		
	bg.position.x -= (Global.velocidade_jogo * delta)
	pass

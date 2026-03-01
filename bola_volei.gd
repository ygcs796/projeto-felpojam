extends RigidBody2D

var posicao_inicial : Vector2
var posicao_adversario = Vector2(200, 29)
var deve_resetar = false
var quem_joga = "player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	posicao_inicial = global_position
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_R):
		deve_resetar = true
		
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if deve_resetar:
		
		if quem_joga == "player":
		
			state.transform.origin = posicao_inicial
			
		elif quem_joga == "adversario":
			
			state.transform.origin = posicao_adversario
			
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0
		deve_resetar = false

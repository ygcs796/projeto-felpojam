extends Node2D

@export var obstacle_scenes: Array[PackedScene]
@export var obstacles_parent: NodePath
@export var spawn_timer_path: NodePath
@export var min_wait := 0.2
@export var max_wait := 0.5
@export var iceberg_scene: PackedScene

@onready var obstacles: Node2D = get_node(obstacles_parent)
@onready var spawn_timer: Timer = get_node(spawn_timer_path)

@onready var spawner = $"."

var spawn_points: Array[Node2D] = []

func _ready() -> void:
	# Pega todos os Marker2D como pontos de spawn
	for child in get_children():
		if child is Marker2D:
			spawn_points.append(child)

	# Garante que o timer está conectado
	spawn_timer.timeout.connect(_spawn)

func _spawn() -> void:
	if obstacle_scenes == null or spawn_points.is_empty():
		return

	# Escolhe um ponto aleatório
	var p: Node2D = spawn_points.pick_random()

	# Instancia e coloca no container de obstáculos
	var scene = obstacle_scenes.pick_random()
	var obstacle = scene.instantiate()
	obstacles.add_child(obstacle)
	obstacle.global_position = p.global_position

	# Muda o tempo de spawn
	spawn_timer.wait_time = randf_range(min_wait, max_wait)

func _on_phase_timer_timeout():
	spawner.spawn_timer.stop()
	await get_tree().create_timer(2.0).timeout
	_spawn_iceberg()
	
func _spawn_iceberg():
	var iceberg = iceberg_scene.instantiate()
	obstacles.add_child(iceberg)
	iceberg.position = Vector2(85, -150)

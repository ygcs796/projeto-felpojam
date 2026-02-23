extends Sprite2D

@onready var falling_keys = preload("res://scenes/falling_keys.tscn")
@export var key_name: String = ""

var falling_keys_queue = []

func _process(delta):
	
	if falling_keys_queue.size() > 0:
		if falling_keys_queue.front().has_passed:
			falling_keys_queue.pop_front()
			print("deletado")
	
		if Input.is_action_just_pressed(key_name):
			var key_to_delete = falling_keys_queue.pop_front()
			
			var distance_from_pass = abs(key_to_delete.pass_threshold - key_to_delete.global_position.y)
			print(distance_from_pass)
			key_to_delete.queue_free()
		
func CreateFallingKey():
	var fk_instance = falling_keys.instantiate()
	get_tree().get_root().call_deferred("add_child", fk_instance)
	fk_instance.Setup(position.x, frame)
	
	falling_keys_queue.push_back(fk_instance)

func _on_spawn_timer_timeout() -> void:
	CreateFallingKey()
	$SpawnTimer.wait_time = randf_range(0.5, 3)
	$SpawnTimer.start()

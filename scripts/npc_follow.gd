extends CharacterBody2D
class_name NpcFollowSimple

@export var sprite_path: NodePath = NodePath("AnimatedSprite2D")

# Animações padrão (Shekira/Lucas etc.)
@export var anim_idle_up: StringName = &"idle_up"
@export var anim_idle_down: StringName = &"idle_down"
@export var anim_idle_right: StringName = &"idle_right"
@export var anim_walk_up: StringName = &"walk_up"
@export var anim_walk_down: StringName = &"walk_down"
@export var anim_walk_right: StringName = &"walk_right"
@export var flip_for_left: bool = true

# ✅ Carlos special (side front/back)
@export var use_side_front_back: bool = false

# Para o Carlos, estes nomes EXISTEM:
@export var anim_idle_left: StringName = &"idle_left"
@export var anim_walk_left_front: StringName = &"walk_left_front"
@export var anim_walk_left_back: StringName = &"walk_left_back"
@export var anim_walk_right_front: StringName = &"walk_right_front"
@export var anim_walk_right_back: StringName = &"walk_right_back"

var tile_size: int = 16
var move_speed: float = 0.3

var _moving: bool = false
var _prev_dir: Vector2 = Vector2.DOWN
var _side_mode_front: bool = true # true = front (down), false = back (up)

@onready var anim: AnimatedSprite2D = get_node_or_null(sprite_path) as AnimatedSprite2D

func set_party_movement(new_tile_size: int, new_move_speed: float) -> void:
	tile_size = new_tile_size
	move_speed = new_move_speed

func join_party() -> void:
	if not is_in_group("party_member"):
		add_to_group("party_member")

	# ✅ DESLIGA interação assim que entra na party (100% garantido)
	var actionable := get_node_or_null("Actionable")
	if actionable != null:
		if actionable.has_method("disable_actionable"):
			actionable.disable_actionable()
		elif actionable is Area2D:
			# fallback caso não esteja com o script
			var a := actionable as Area2D
			a.monitoring = false
			a.monitorable = false
			var col := a.get_node_or_null("CollisionShape2D") as CollisionShape2D
			if col:
				col.disabled = true
			var lbl := a.get_node_or_null("Label") as Label
			if lbl:
				lbl.visible = false

func party_step_to(target_global_pos: Vector2) -> void:
	if _moving:
		return

	var delta := target_global_pos - global_position

	if delta.length() < 0.1:
		_play_idle(_prev_dir)
		return

	var dir := Vector2.ZERO
	if abs(delta.x) > abs(delta.y):
		dir = Vector2.RIGHT if delta.x > 0 else Vector2.LEFT
	else:
		dir = Vector2.DOWN if delta.y > 0 else Vector2.UP

	_prev_dir = dir
	if dir == Vector2.UP:
		_side_mode_front = false
	elif dir == Vector2.DOWN:
		_side_mode_front = true

	_play_walk(dir)

	_moving = true
	var tween := create_tween()
	tween.tween_property(self, "global_position", target_global_pos, move_speed)
	tween.finished.connect(func():
		_moving = false
		_play_idle(_prev_dir)
	)

func _play_walk(dir: Vector2) -> void:
	if anim == null:
		return

	if dir == Vector2.UP:
		_safe_play(anim_walk_up)
		return
	if dir == Vector2.DOWN:
		_safe_play(anim_walk_down)
		return

	if use_side_front_back:
		if dir == Vector2.RIGHT:
			_safe_play(anim_walk_right_front if _side_mode_front else anim_walk_right_back)
		else:
			_safe_play(anim_walk_left_front if _side_mode_front else anim_walk_left_back)
	else:
		if dir == Vector2.RIGHT:
			anim.flip_h = false
			_safe_play(anim_walk_right)
		else:
			anim.flip_h = flip_for_left
			_safe_play(anim_walk_right)

func _play_idle(dir: Vector2) -> void:
	if anim == null:
		return

	if dir == Vector2.UP:
		_safe_play(anim_idle_up)
		return
	if dir == Vector2.DOWN:
		_safe_play(anim_idle_down)
		return

	if use_side_front_back:
		if dir == Vector2.RIGHT:
			_safe_play(anim_idle_right)
		else:
			_safe_play(anim_idle_left)
	else:
		if dir == Vector2.RIGHT:
			anim.flip_h = false
			_safe_play(anim_idle_right)
		else:
			anim.flip_h = flip_for_left
			_safe_play(anim_idle_right)

func _safe_play(name: StringName) -> void:
	if name == &"":
		return
	if anim.animation != name:
		anim.play(name)

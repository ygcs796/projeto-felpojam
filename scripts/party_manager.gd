extends Node

var pending: Array[Node] = []
var party: Array[Node] = []

var player: Node2D = null
var positions: Array[Vector2] = [] # histórico de posições do player

# Config igual ao Player (para os NPCs andarem igual)
var tile_size: int = 16
var move_speed: float = 0.3

func _ready() -> void:
	call_deferred("_bind_player")

func _bind_player() -> void:
	player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		push_warning("PartyManager: Player não encontrado no grupo 'player'.")
		return

	# pega tile_size/move_speed do player (fallback se não existir)
	var ts = player.get("tile_size")
	if ts != null:
		tile_size = int(ts)

	var ms = player.get("move_speed")
	if ms != null:
		move_speed = float(ms)

	positions.clear()
	positions.append(player.global_position)

	# conecta no sinal do player
	if player.has_signal("step_finished"):
		player.step_finished.connect(_on_player_step_finished)
	else:
		push_warning("PartyManager: Player não tem sinal step_finished.")

func register_pending(npc: Node) -> void:
	if npc == null:
		return
	if not pending.has(npc):
		pending.append(npc)

func recruit_pending() -> void:
	for npc in pending:
		if is_instance_valid(npc) and npc.has_method("join_party"):
			_add_to_party(npc)
	pending.clear()
	_rebuild_party_settings()

func _add_to_party(npc: Node) -> void:
	if party.has(npc):
		return
	party.append(npc)

	# “cola” o NPC na cauda imediatamente
	if party.size() == 1:
		npc.global_position = player.global_position
	else:
		var tail := party[party.size() - 2]
		if is_instance_valid(tail):
			npc.global_position = (tail as Node2D).global_position

func _rebuild_party_settings() -> void:
	# dá aos NPCs acesso ao tile_size e move_speed
	for npc in party:
		if is_instance_valid(npc) and npc.has_method("set_party_movement"):
			npc.set_party_movement(tile_size, move_speed)

func _on_player_step_finished(new_pos: Vector2) -> void:
	positions.append(new_pos)

	# limita histórico para não crescer infinito
	if positions.size() > 200:
		positions.pop_front()

	# comando “cobra”:
	# follower 0 -> posição do player de 1 passo atrás (positions[-2])
	# follower 1 -> posição de 2 passos atrás (positions[-3]) etc.
	for i in range(party.size()):
		var npc := party[i]
		if not is_instance_valid(npc):
			continue

		var index_from_end := i + 2
		if positions.size() < index_from_end:
			continue

		var target_pos := positions[positions.size() - index_from_end]
		if npc.has_method("party_step_to"):
			npc.party_step_to(target_pos)

extends YSort
class_name GameRoom

onready var _roads := $Roads
onready var _doodads := $Doodads
onready var _top_place_position := $PlacePositions/Top
onready var _right_place_position := $PlacePositions/Right
onready var _bottom_place_position := $PlacePositions/Bottom
onready var _left_place_position := $PlacePositions/Left
onready var _safety_timer := $SafetyTimer
onready var _position := $Position

var room_position : Vector2
var room_type : int

var is_safe := false
var is_handled := false

func _ready() -> void:
	var layout = Generation.get_room_layout()

	Generation.add_room_tiles(_roads, layout)
	Generation.add_room_doodads(_doodads, layout)

	_roads.update_bitmask_region(Vector2(0, 0), Vector2(Constants.tiles_width, Constants.tiles_width))

	reset()

func reset() -> void:
	is_handled = false
	is_safe = false
	_safety_timer.start()

func get_offset_for_neighbour(neighbour : int) -> Vector2:
	match neighbour:
		Constants.neighbours.top:
			return Vector2(0, -1) + room_position
		Constants.neighbours.right:
			return Vector2(1, 0) + room_position
		Constants.neighbours.bottom:
			return Vector2(0, 1) + room_position
		Constants.neighbours.left:
			return Vector2(-1, 0) + room_position

	return Vector2.INF

func has_neighbour(neighbour : int) -> bool:
	var offset = get_offset_for_neighbour(neighbour)

	if offset == Vector2.INF:
		return false

	return Variables.room_positions_taken.has(offset)

func get_neighbour(neighbour : int) -> GameRoom:
	var offset := get_offset_for_neighbour(neighbour)

	for next_room in Variables.rooms_made:
		if next_room.room_position == offset:
			return next_room

	return null

func free_side() -> int:
	for neighbour in Constants.neighbours.values():
		if not has_neighbour(neighbour):
			return neighbour

	return -1

func add_player(player : Player, new_position = null) -> void:
	var parent = player.get_parent()

	if parent:
		parent.remove_child(player)

	add_child(player)

	if new_position is Vector2:
		player.global_position = new_position

	elif room_type == Constants.rooms_types.first:
		var free_side = free_side()
		var place_position : Vector2

		match free_side:
			Constants.neighbours.top:
				place_position = _top_place_position.global_position
			Constants.neighbours.right:
				place_position = _right_place_position.global_position
			Constants.neighbours.bottom:
				place_position = _bottom_place_position.global_position
			Constants.neighbours.left:
				place_position = _left_place_position.global_position

		player.global_position = place_position


func _on_Top_body_entered(body: Node) -> void:
	on_body_entered(body, Constants.neighbours.top, Vector2(body.global_position.x, _bottom_place_position.global_position.y))

func _on_Right_body_entered(body: Node) -> void:
	on_body_entered(body, Constants.neighbours.right, Vector2(_left_place_position.global_position.x, body.global_position.y))

func _on_Bottom_body_entered(body: Node) -> void:
	on_body_entered(body, Constants.neighbours.bottom, Vector2(body.global_position.x, _top_place_position.global_position.y))

func _on_Left_body_entered(body: Node) -> void:
	on_body_entered(body, Constants.neighbours.left, Vector2(_right_place_position.global_position.x, body.global_position.y))

func on_body_entered(body : Node, neighbour : int, position : Vector2) -> void:
	if not is_safe or is_handled:
		return

	if not has_neighbour(neighbour):
		return

	if body is Player:
		is_handled = true

		var found_neighbour = get_neighbour(neighbour)

		Variables.current_room.visible = false

		Variables.player_last_position = body.position
		body.path = PoolVector2Array()

		Variables.current_room = found_neighbour
		Variables.current_room.visible = true
		Variables.current_room.reset()
		Variables.current_room.add_player(body, position)

func _on_SafetyTimer_timeout() -> void:
	is_safe = true
	_position.text = str(room_position)

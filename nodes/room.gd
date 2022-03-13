extends YSort
class_name GameRoom

export (Array, PackedScene) var survivor_scenes

onready var _roads := $Roads
onready var _doodads := $Doodads
onready var _survivors := $Survivors
onready var _top_place_position := $PlacePositions/Top
onready var _right_place_position := $PlacePositions/Right
onready var _bottom_place_position := $PlacePositions/Bottom
onready var _left_place_position := $PlacePositions/Left
onready var _top_arrow := $Arrows/Top
onready var _right_arrow := $Arrows/Right
onready var _bottom_arrow := $Arrows/Bottom
onready var _left_arrow := $Arrows/Left

var layout : Array

var room_position : Vector2
var room_type : int

func _ready() -> void:
	layout = Generation.get_room_layout()

	Generation.add_room_tiles(_roads, layout)
	Generation.add_room_doodads(_doodads, layout)

	_roads.update_bitmask_region(Vector2(0, 0), Vector2(Constants.tiles_width, Constants.tiles_width))

func get_neighbor_positions() -> Dictionary:
	return {
		Constants.neighbours.top: Vector2(room_position.x, room_position.y - 1),
		Constants.neighbours.right: Vector2(room_position.x + 1, room_position.y),
		Constants.neighbours.bottom: Vector2(room_position.x, room_position.y + 1),
		Constants.neighbours.left: Vector2(room_position.x - 1, room_position.y),
	}

func get_neighbor_position(neighbour : int) -> Vector2:
	return get_neighbor_positions()[neighbour]

func has_neighbour(neighbour : int) -> bool:
	var offset = get_neighbor_positions()[neighbour]
	return Variables.room_positions_taken.has(offset)

func get_neighbour(neighbour : int) -> GameRoom:
	var offset = get_neighbor_positions()[neighbour]

	for next_room in Variables.rooms_made:
		if next_room.room_position == offset:
			return next_room

	return null

func free_side() -> int:
	for neighbour in Constants.neighbours.values():
		if not has_neighbour(neighbour):
			return neighbour

	return -1

func add_player(move_to : int) -> void:
	var parent = Variables.current_player.get_parent()
	var survivors := []

	if parent:
		parent.remove_child(Variables.current_player)

		for survivor in get_tree().get_nodes_in_group("survivors"):
			if survivor.is_following_player:
				survivors.append(survivor)
				survivor.get_parent().remove_child(survivor)

	# this drops most race condition errors when the player is added to the new room
	yield(get_tree().create_timer(0.05), "timeout")

	add_child(Variables.current_player)

	var place_position : Vector2
	var is_horizontal = true

	match move_to:
		Constants.neighbours.top:
			place_position = _top_place_position.global_position
			is_horizontal = false
		Constants.neighbours.right:
			place_position = _right_place_position.global_position
		Constants.neighbours.bottom:
			place_position = _bottom_place_position.global_position
			is_horizontal = false
		Constants.neighbours.left:
			place_position = _left_place_position.global_position

	if Variables.player_last_position:
		if is_horizontal:
			Variables.current_player.global_position = Vector2(place_position.x, Variables.player_last_position.y)
		else:
			Variables.current_player.global_position = Vector2(Variables.player_last_position.x, place_position.y)
	else:
		Variables.current_player.global_position = place_position

	for survivor in survivors:
		_survivors.add_child(survivor)
		survivor.path = PoolVector2Array()

		var variance = Vector2(
			rand_range(round(Constants.survivors_variance / -2.0), round(Constants.survivors_variance / 2.0)),
			rand_range(round(Constants.survivors_variance / -2.0), round(Constants.survivors_variance / 2.0))
		)

		survivor.global_position = Variables.current_player.global_position + variance

func _on_Top_body_entered(body: Node) -> void:
	on_body_entered(body, Constants.neighbours.top, Constants.neighbours.bottom)

func _on_Right_body_entered(body: Node) -> void:
	on_body_entered(body, Constants.neighbours.right, Constants.neighbours.left)

func _on_Bottom_body_entered(body: Node) -> void:
	on_body_entered(body, Constants.neighbours.bottom, Constants.neighbours.top)

func _on_Left_body_entered(body: Node) -> void:
	on_body_entered(body, Constants.neighbours.left, Constants.neighbours.right)

func on_body_entered(body : Node, neighbour : int, move_to : int) -> void:
	if not body is Player:
		return

	if not has_neighbour(neighbour):
		return

	if Variables.is_moving_rooms:
		return

	Variables.is_moving_rooms = true
	body.disable_collider()

	var found_neighbour = get_neighbour(neighbour)
	found_neighbour.enter_with_player(move_to)

func enter_with_player(move_to : int) -> void:
	get_tree().call_group("exits", "disable_collider")

	if Variables.current_room:
		Variables.player_last_position = Variables.current_player.global_position
		Variables.current_room.position = Constants.rooms_hidden_offset

		if Constants.rooms_change_visibility:
			Variables.current_room.visible = false

		Variables.current_room.hide()

	Variables.current_player.path = PoolVector2Array()

	Variables.current_room = self
	Variables.current_room.position = Vector2(0, 0)

	if Constants.rooms_change_visibility:
		Variables.current_room.visible = true

	Variables.current_room.show()
	Variables.current_room.add_player(move_to)

	print("new room position: " + str(Variables.current_room.room_position))

	yield(get_tree().create_timer(0.1), "timeout")

	get_tree().call_group("exits", "enable_collider")

	Variables.current_player.enable_collider()
	Variables.is_moving_rooms = false

func show() -> void:
	get_tree().call_group("arrows", "set_visible", false)

	yield(get_tree().create_timer(0.1), "timeout")

	if has_neighbour(Constants.neighbours.top):
		_top_arrow.visible = true

	if has_neighbour(Constants.neighbours.right):
		_right_arrow.visible = true

	if has_neighbour(Constants.neighbours.bottom):
		_bottom_arrow.visible = true

	if has_neighbour(Constants.neighbours.left):
		_left_arrow.visible = true

func hide() -> void:
	pass

func spawn_survivors() -> void:
	randomize()

	var used_coordinates := []

	for i in rand_range(Constants.survivors_min_per_room, Constants.survivors_max_per_room):
		var new_survivor : Survivor = survivor_scenes[randi() % survivor_scenes.size()].instance()
		_survivors.add_child(new_survivor)

		var potential_characters := []

		for character in Generation.characters_data:
			if "survivor" in character.name:
				if new_survivor.is_in_group("males") and "-male-" in character.name:
					potential_characters.append(character)
				if new_survivor.is_in_group("females") and "-female-" in character.name:
					potential_characters.append(character)

		if potential_characters.size() > 0:
			new_survivor.character = potential_characters[randi() % potential_characters.size()]

		var coordinates = Vector2(randi() % Constants.tiles_width, randi() % Constants.tiles_width)
		var location = layout[coordinates.y][coordinates.x]

		while location != Constants.tiles_types.grass or used_coordinates.has(coordinates):
			coordinates = Vector2(randi() % Constants.tiles_width, randi() % Constants.tiles_width)
			location = layout[coordinates.y][coordinates.x]

		used_coordinates.append(coordinates)

		new_survivor.position = Vector2(
			coordinates.x * Constants.sprites_width + round(Constants.sprites_width / 2.0),
			coordinates.y * Constants.sprites_width + round(Constants.sprites_width / 2.0)
		)

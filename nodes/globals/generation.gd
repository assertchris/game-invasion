extends Node

export var room_scene : PackedScene

var tiles_data : Image

func _ready() -> void:
	get_tile_data()

func get_tile_data() -> void:
	tiles_data = Constants.tiles.get_data()
	tiles_data.lock()

func get_room_layout() -> Array:
	randomize()

	var offset = (randi() % Constants.tiles_count) * Constants.tiles_width
	var room = []

	for y in range(Constants.tiles_width):
		var row = []

		for x in range(Constants.tiles_width):
			var tile_type = Constants.tiles_types.none
			var pixel_color = tiles_data.get_pixel(x + offset, y).to_html(false)

			for type in Constants.tiles_colors.keys():
				if pixel_color == Constants.tiles_colors[type]:
					tile_type = type
					continue

			row.push_back(tile_type)

		room.push_back(row)

	return room

func add_room_tiles(parent, layout: Array) -> void:
	for y in range(Constants.tiles_width):
		for x in range(Constants.tiles_width):
			if Constants.tiles_is_not_tile.has(layout[y][x]):
				continue

			var name = Constants.tiles_set_names[layout[y][x]]
			var id = parent.tile_set.find_tile_by_name(name)
			parent.set_cell(x, y, id)

func add_room_doodads(parent, layout: Array) -> void:
	for y in range(Constants.tiles_width):
		for x in range(Constants.tiles_width):
			if Constants.tiles_is_not_doodad.has(layout[y][x]):
				continue

			var doodad = Constants.tiles_doodads[layout[y][x]].instance()
			parent.add_child(doodad)

			doodad.position = Vector2(
				x * Constants.sprites_width,
				y * Constants.sprites_width
			)

func make_rooms(parent, player):
	randomize()

	var rooms_left = Constants.rooms_total - 1
	var room_position_options = []

	var rooms_made = []
	var room_positions_taken = []

	var first_room = room_scene.instance()
	var first_room_position = Vector2(0, 0)

	rooms_made.push_back([first_room, first_room_position, Constants.rooms_types.first])
	room_positions_taken.push_back(first_room_position)

	room_position_options += get_neighbor_positions(first_room_position)

	while rooms_left > 0:
		var array_index = randi() % room_position_options.size()
		var next_room_position = room_position_options[array_index]

		room_position_options.remove(array_index)

		var next_room_type = Constants.rooms_types.normal

		if rooms_left == 1:
			next_room_type = Constants.rooms_types.last

		var next_room = room_scene.instance()

		rooms_made.push_back([next_room, next_room_position, next_room_type])
		room_positions_taken.push_back(next_room_position)

		var next_room_neighbors = get_neighbor_positions(next_room_position)

		if not room_positions_taken.has(next_room_neighbors[0]):
			room_position_options.push_back(next_room_neighbors[0])

		if not room_positions_taken.has(next_room_neighbors[1]):
			room_position_options.push_back(next_room_neighbors[1])

		if not room_positions_taken.has(next_room_neighbors[2]):
			room_position_options.push_back(next_room_neighbors[2])

		if not room_positions_taken.has(next_room_neighbors[3]):
			room_position_options.push_back(next_room_neighbors[3])

		rooms_left -= 1

	for room in rooms_made:
		if room[1] == first_room_position:
			continue

		parent.add_child(room[0])
		room[0].visible = false

	Variables.current_room = first_room
	parent.add_child(Variables.current_room)

	Variables.current_room.visible = true
	Variables.current_room.add_child(player)

func get_neighbor_positions(position) -> Array:
	return [
		Vector2(position.x, position.y - 1),
		Vector2(position.x + 1, position.y),
		Vector2(position.x, position.y + 1),
		Vector2(position.x - 1, position.y),
	]

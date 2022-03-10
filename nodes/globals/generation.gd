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

func make_rooms(parent, player) -> void:
	randomize()

	var rooms_left = Constants.rooms_total - 1

	Variables.room_position_options = []
	Variables.room_positions_taken = []
	Variables.rooms_made = []

	var first_room = room_scene.instance()
	first_room.room_position = Vector2(0, 0)
	first_room.room_type = Constants.rooms_types.first

	Variables.room_position_options += get_neighbor_positions(first_room.room_position)
	Variables.room_positions_taken.push_back(first_room.room_position)
	Variables.rooms_made.push_back(first_room)

	var except_array_index = randi() % Variables.room_position_options.size()
	var except_room_position = Variables.room_position_options[except_array_index]
	Variables.room_position_options.remove(except_array_index)

	while rooms_left > 0:
		var array_index = randi() % Variables.room_position_options.size()
		var next_room_position = Variables.room_position_options[array_index]

		var next_room_type = Constants.rooms_types.normal

		if rooms_left == 1:
			next_room_type = Constants.rooms_types.last

		var next_room = room_scene.instance()
		next_room.room_position = next_room_position
		next_room.room_type = next_room_type

		Variables.room_positions_taken.push_back(next_room_position)
		Variables.rooms_made.push_back(next_room)

		var next_room_neighbors = get_neighbor_positions(next_room_position)

		for next_room_option in next_room_neighbors:
			if not Variables.room_positions_taken.has(next_room_option) and except_room_position != next_room_option:
				Variables.room_position_options.push_back(next_room_option)

		rooms_left -= 1

	for room in Variables.rooms_made:
		parent.add_child(room)
		room.visible = false

	Variables.current_room = first_room
	Variables.current_room.visible = true
	Variables.current_room.add_player(player)

func get_neighbor_positions(position) -> Array:
	return [
		Vector2(position.x, position.y - 1),
		Vector2(position.x + 1, position.y),
		Vector2(position.x, position.y + 1),
		Vector2(position.x - 1, position.y),
	]

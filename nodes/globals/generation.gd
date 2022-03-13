extends Node

export var room_scene : PackedScene

var tiles_data : Image
var characters_data : Array

func _ready() -> void:
	get_tile_data()
	get_character_data()

func get_tile_data() -> void:
	tiles_data = Constants.tiles.get_data()
	tiles_data.lock()

func get_character_data() -> void:
	characters_data = DialogicUtil.get_sorted_character_list()

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
				x * Constants.sprites_width + round(Constants.sprites_width / 2.0),
				y * Constants.sprites_width + round(Constants.sprites_width / 2.0)
			)

func make_rooms(parent) -> void:
	randomize()

	var rooms_left = Constants.rooms_total - 1

	Variables.room_position_options = []
	Variables.room_positions_taken = []
	Variables.rooms_made = []

	var first_room = room_scene.instance()
	parent.add_child(first_room)
	first_room.room_position = Vector2(0, 0)
	first_room.room_type = Constants.rooms_types.first
	first_room.position = Constants.rooms_hidden_offset

	if Constants.rooms_change_visibility:
		first_room.visible = false

	Variables.room_position_options += first_room.get_neighbor_positions().values()
	Variables.room_positions_taken.append(first_room.room_position)
	Variables.rooms_made.append(first_room)

	# make sure the first room has one open side
	var except_room_position = Variables.room_position_options[randi() % Variables.room_position_options.size()]
	Variables.room_position_options.erase(except_room_position)

	while rooms_left > 0:
		var next_room_position = Variables.room_position_options[randi() % Variables.room_position_options.size()]
		Variables.room_position_options.erase(next_room_position)

		var next_room_type = Constants.rooms_types.normal

		if rooms_left == 1:
			next_room_type = Constants.rooms_types.last

		var next_room = room_scene.instance()
		parent.add_child(next_room)
		next_room.room_position = next_room_position
		next_room.room_type = next_room_type
		next_room.position = Constants.rooms_hidden_offset
		next_room.spawn_survivors()

		if Constants.rooms_change_visibility:
			next_room.visible = false

		Variables.room_positions_taken.append(next_room_position)
		Variables.rooms_made.append(next_room)

		for next_room_option in next_room.get_neighbor_positions().values():
			if not Variables.room_positions_taken.has(next_room_option) and not Variables.room_position_options.has(next_room_option) and except_room_position != next_room_option:
				Variables.room_position_options.append(next_room_option)

		rooms_left -= 1

	var debug_room_positions := []

	for room in Variables.rooms_made:
		debug_room_positions.append(room.room_position)

	first_room.enter_with_player(first_room.free_side())

extends Node

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

	print(Constants.tiles_count)
	print(Constants.tiles_width)
	print(offset)

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

func draw_room_doodads(parent, layout: Array) -> void:
	for y in range(Constants.tiles_width):
		var row = []

		for x in range(Constants.tiles_width):
			if layout[y][x] == Constants.tiles_types.none:
				continue

			var doodad = Constants.tiles_doodads[layout[y][x]].instance()
			parent.add_child(doodad)
			doodad.position = Vector2(x * 12, y * 12)

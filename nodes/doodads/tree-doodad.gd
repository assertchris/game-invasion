extends Doodad

onready var _tiles := $Tiles

func _on_DrawTimer_timeout() -> void:
	randomize()

	var chance = rand_range(0, 100)

	var trees := [
		_tiles.tile_set.find_tile_by_name("tree-1"),
		_tiles.tile_set.find_tile_by_name("tree-2"),
		_tiles.tile_set.find_tile_by_name("tree-3"),
	]

	var grass := [
		_tiles.tile_set.find_tile_by_name("grass-1"),
		_tiles.tile_set.find_tile_by_name("grass-2"),
	]

	var blank = _tiles.tile_set.find_tile_by_name("blank")

	if chance >= 75:
		_tiles.set_cell(0, 0, trees[randi() % trees.size()])
	elif chance >= 50:
		_tiles.set_cell(0, 0, grass[randi() % grass.size()])
	else:
		_tiles.set_cell(0, 0, blank)

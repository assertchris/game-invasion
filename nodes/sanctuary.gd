extends Node2D

export var is_ending := false

onready var _tiles := $Tiles

func _on_UpdateAppearanceTimer_timeout() -> void:
	if is_ending:
		_tiles.set_cell(3, 1, -1)
		_tiles.set_cell(1, 2, -1)
		_tiles.set_cell(3, 2, _tiles.tile_set.find_tile_by_name("fire"))

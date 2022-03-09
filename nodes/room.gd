extends Node2D

onready var _roads := $Roads
onready var _doodads := $Doodads

func _ready() -> void:
	var layout = Generation.get_room_layout()
	Generation.add_room_tiles(_roads, layout)
	Generation.add_room_doodads(_doodads, layout)

	_roads.update_bitmask_region(Vector2(0, 0), Vector2(Constants.tiles_width, Constants.tiles_width))

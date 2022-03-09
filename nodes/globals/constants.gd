extends Node

export var tiles : Texture

const tiles_width := 11
const tiles_count := 4

enum tiles_types {
	none,
	tree,
	grave,
	house,
	road,
}

const tiles_colors := {
	tiles_types.tree: "22c55e",
	tiles_types.grave: "71717a",
	tiles_types.house: "ef4444",
	tiles_types.road: "a855f7",
}

export var tree_doodad : PackedScene
export var grave_doodad : PackedScene
export var house_doodad : PackedScene

onready var tiles_doodads := {
	tiles_types.tree: tree_doodad,
	tiles_types.grave: grave_doodad,
	tiles_types.house: house_doodad,
}

const tiles_set_names := {
	tiles_types.road: "roads",
}

const rooms_total := 9

enum rooms_types {
	first,
	normal,
	last,
}

const tiles_is_not_doodad := [
	tiles_types.none,
	tiles_types.road,
]

const tiles_is_not_tile := [
	tiles_types.none,
	tiles_types.tree,
	tiles_types.grave,
	tiles_types.house,
]

const sprites_width := 12

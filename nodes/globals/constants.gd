extends Node

export var tiles : Texture
export (Array, AudioStream) var menu_tracks
export (Array, AudioStream) var level_tracks

export (PackedScene) var credits_scene
export (PackedScene) var menu_scene
export (PackedScene) var patrons_scene
export (PackedScene) var play_scene
export (PackedScene) var settings_scene

const tiles_width := 11
const tiles_count := 4

enum tiles_types {
	none,
	tree,
	grave,
	house,
	road,
	grass,
}

const tiles_colors := {
	tiles_types.tree: "22c55e",
	tiles_types.grave: "71717a",
	tiles_types.house: "ef4444",
	tiles_types.road: "a855f7",
	tiles_types.grass: "fbbf24",
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
	tiles_types.grass: "navigable",
}

const rooms_total := 9

enum rooms_types {
	first = 0,
	normal = 1,
	last = 2,
}

const tiles_is_not_doodad := [
	tiles_types.none,
	tiles_types.road,
	tiles_types.grass,
]

const tiles_is_not_tile := [
	tiles_types.none,
	tiles_types.tree,
	tiles_types.grave,
	tiles_types.house,
]

const sprites_width := 12

const player_speed = 100.0

enum neighbours {
	top = 0,
	right = 1,
	bottom = 2,
	left = 3,
}

const rooms_hidden_offset := Vector2(-140, -140)
const rooms_change_visibility := true

const survivors_min_per_room := 0
const survivors_max_per_room := 1
const survivors_variance := 32

enum screens {
	none,
	credits,
	menu,
	patrons,
	play,
	settings,
}

onready var screens_scenes := {
	screens.credits : credits_scene,
	screens.menu : menu_scene,
	screens.patrons : patrons_scene,
	screens.play : play_scene,
	screens.settings : settings_scene,
}

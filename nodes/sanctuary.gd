extends Node2D

export var is_ending := false

onready var _first_tiles := $FirstTiles
onready var _last_tiles := $LastTiles

func _on_UpdateAppearanceTimer_timeout() -> void:
	_first_tiles.visible = not is_ending
	_last_tiles.visible = is_ending

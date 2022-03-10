extends Screen

export var Player : PackedScene

onready var _anchor := $Center/Anchor
onready var _navigation := $Center/Anchor/Navigation

var _player : KinematicBody2D

func _ready() -> void:
	# DEBUG add delay because play is loaded first
	yield(get_tree().create_timer(0.25), "timeout")

	_player = Player.instance()
	Generation.make_rooms(_navigation, _player)

func _on_PlayScreen_gui_input(event: InputEvent) -> void:
	if not _player:
		return

	if event is InputEventMouseButton:
		if event.is_pressed():
			var position = get_local_mouse_position() - _anchor.rect_position
			_player.set_path(_navigation.get_simple_path(_player.position, position, false))

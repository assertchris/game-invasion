extends Screen

export var Player : PackedScene

onready var _anchor := $Center/Anchor
onready var _navigation := $Center/Anchor/Navigation
onready var _restart_music_timer := $RestartMusicTimer

var _player : KinematicBody2D

func _ready() -> void:
	# DEBUG add delay because play is loaded first
	yield(get_tree().create_timer(0.25), "timeout")

	play_music()
	Audio.connect("music_finished", self, "restart_music_timer")

	_player = Player.instance()
	Generation.make_rooms(_navigation, _player)

	Variables.current_navigation = _navigation

func play_music() -> void:
	randomize()
	Audio.play_music(Constants.level_tracks[randi() % Constants.level_tracks.size()])

func _unhandled_input(event: InputEvent) -> void:
	if not _player:
		return

	if event is InputEventMouseButton:
		if event.is_pressed():
			randomize()

			var position = get_local_mouse_position() - _anchor.rect_position
			var path = _navigation.get_simple_path(_player.position, position, false)

			_player.set_path(path)

			for survivor in get_tree().get_nodes_in_group("survivors"):
				var variance = Vector2(
					rand_range(Constants.survivors_variance / -2, Constants.survivors_variance / 2),
					rand_range(Constants.survivors_variance / -2, Constants.survivors_variance / 2)
				)

				var variant_path = Variables.current_navigation.get_simple_path(_player.position, position + variance, false)

				survivor.follow(variant_path)

func restart_music_timer() -> void:
	_restart_music_timer.start()

func _on_RestartMusicTimer_timeout() -> void:
	play_music()

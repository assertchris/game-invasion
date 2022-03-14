extends Screen

export var Player : PackedScene

onready var _anchor := $Center/Anchor
onready var _navigation := $Center/Anchor/Navigation
onready var _restart_music_timer := $RestartMusicTimer
onready var _dialog := $Dialog
onready var _survivor_dialog_timer := $SurvivorDialogTimer
onready var _rescued_label := $Status/RescuedLabel

var _player : KinematicBody2D
var can_show_dialog := true

func _ready() -> void:
	# DEBUG add delay because play is loaded first
	yield(get_tree().create_timer(0.25), "timeout")

	play_music()

	Audio.connect("music_finished", self, "restart_music_timer")

	Variables.current_player = Player.instance()
	Variables.current_navigation = _navigation

	Generation.make_rooms(Variables.current_navigation)

	get_tree().call_group("survivors", "connect", "acquired", self, "on_acquired")
	get_tree().call_group("survivors", "connect", "rescued", self, "on_rescued")

func play_music() -> void:
	randomize()
	Audio.play_music(Constants.level_tracks[randi() % Constants.level_tracks.size()])

func _unhandled_input(event: InputEvent) -> void:
	if not Variables.current_player:
		return

	if event is InputEventMouseButton:
		if event.is_pressed():
			randomize()

			var position = get_local_mouse_position() - _anchor.rect_position
			var path = _navigation.get_simple_path(Variables.current_player.position, position, false)

			Variables.current_player.set_path(path)

			for survivor in get_tree().get_nodes_in_group("survivors"):
				var variance = Vector2(
					rand_range(round(Constants.survivors_variance / -2.0), round(Constants.survivors_variance / 2.0)),
					rand_range(round(Constants.survivors_variance / -2.0), round(Constants.survivors_variance / 2.0))
				)

				var variant_path = Variables.current_navigation.get_simple_path(Variables.current_player.position, position + variance, false)

				survivor.follow(variant_path)

func restart_music_timer() -> void:
	_restart_music_timer.start()

func _on_RestartMusicTimer_timeout() -> void:
	play_music()

func on_acquired(survivor : Survivor) -> void:
	if not can_show_dialog:
		return

	if not survivor.character:
		return

	can_show_dialog = false
	_dialog.show_acquired_dialog(survivor.character)
	_survivor_dialog_timer.start()

func on_rescued(survivor : Survivor) -> void:
	if not can_show_dialog:
		return

	if not survivor.character:
		return

	can_show_dialog = false
	_dialog.show_rescued_dialog(survivor.character)
	_survivor_dialog_timer.start()

func _on_SurvivorDialogTimer_timeout() -> void:
	can_show_dialog = true

func _on_UpdateStatusTimer_timeout() -> void:
	var total := 0
	var rescued := 0

	for survivor in get_tree().get_nodes_in_group("survivors"):
		total += 1

		if survivor.status == Constants.survivors_statuses.rescued:
			rescued += 1

	_rescued_label.text = str(rescued) + "/" + str(total) + " rescued"

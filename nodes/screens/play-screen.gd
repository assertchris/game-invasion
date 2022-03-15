extends Screen

export var Player : PackedScene

onready var _anchor := $Center/Anchor
onready var _navigation := $Center/Anchor/Navigation
onready var _restart_music_timer := $RestartMusicTimer
onready var _dialog := $Dialog
onready var _survivor_dialog_timer := $SurvivorDialogTimer
onready var _rescued_label := $Status/RescuedLabel
onready var _hope_label := $Status/HopeLabel
onready var _unstuck_button := $Status/UnstuckButton

var _player : KinematicBody2D
var can_show_dialog := true

func _ready() -> void:
	_unstuck_button.visible = false

	Variables.current_room = null
	Variables.current_player = null
	Variables.player_last_position = Vector2.INF

	play_music()
	Audio.connect("music_finished", self, "restart_music_timer")

	Variables.current_player = Player.instance()
	Variables.current_navigation = _navigation

	Generation.make_rooms(Variables.current_navigation)

	get_tree().call_group("survivors", "connect", "acquired", self, "on_acquired")
	get_tree().call_group("survivors", "connect", "rescued", self, "on_rescued")
	get_tree().call_group("soldiers", "connect", "captured", self, "on_captured")

func play_music() -> void:
	randomize()
	Audio.play_music(Constants.level_tracks[randi() % Constants.level_tracks.size()])

func _unhandled_input(event: InputEvent) -> void:
	if not Variables.current_player:
		return

	if event is InputEventMouseButton:
		if event.is_action("ui_left_click"):
			randomize()

			var position = get_local_mouse_position() - _anchor.rect_position
			var path = Variables.current_navigation.get_simple_path(Variables.current_player.position, position, true)

			Variables.current_player.set_path(path)
			Variables.current_clicks += 1

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
	Variables.stored.hope += Constants.hope_rescue_amount
	Variables.stored.rescued += 1

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
		if survivor.status != Constants.survivors_statuses.captured:
			total += 1

		if survivor.status == Constants.survivors_statuses.rescued:
			rescued += 1

	_rescued_label.text = str(rescued) + "/" + str(total) + " rescued"
	_hope_label.text = str(Variables.stored.hope) + " hope"

func _on_ChasePlayerTimer_timeout() -> void:
	for soldier in get_tree().get_nodes_in_group("soldiers"):
		if soldier.status == Constants.soldiers_statuses.following:
			var path = _navigation.get_simple_path(soldier.position, Variables.current_player.position, false)
			soldier.set_path(path)

func on_captured(soldier : Soldier) -> void:
	for survivor in get_tree().get_nodes_in_group("survivors"):
		if survivor.status == Constants.survivors_statuses.following:
			if not survivor.character:
				continue

			survivor.status = Constants.survivors_statuses.captured
			_dialog.show_captured_dialog(survivor.character, soldier.character)
			Variables.stored.hope = clamp(Variables.stored.hope - Constants.hope_capture_amount, 0, INF)
			return

	_dialog.show_harass_dialog(soldier.character)
	Variables.stored.hope = clamp(Variables.stored.hope - Constants.hope_harass_amount, 0, INF)

func _on_DecayHopeTimer_timeout() -> void:
	Variables.stored.hope = clamp(Variables.stored.hope - Constants.hope_decay_amount, 0, INF)

	if Variables.stored.hope <= 0:
		Audio.fade_out()
		Screens.change_screen(Constants.screens.game_over)

func _on_UnstuckButton_pressed() -> void:
	var points = get_tree().get_nodes_in_group("place-positions")
	var nearest_point = points[0]

	for point in points:
		if point.global_position.distance_to(Variables.current_player.global_position) < nearest_point.global_position.distance_to(Variables.current_player.global_position):
			nearest_point = point

	Variables.current_player.global_position = nearest_point.global_position

func _on_UnstuckTimer_timeout() -> void:
	if Variables.current_clicks > 2:
		_unstuck_button.visible = true
	else:
		_unstuck_button.visible = false

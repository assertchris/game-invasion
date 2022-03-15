extends Node

signal music_finished
signal sound_finished
signal faded_out

onready var _music_player := $MusicPlayer
onready var _sound_player := $SoundPlayer
onready var _restart_menu_music_timer := $RestartMenuMusicTimer

var is_playing_menu_music := false
var sounds_bus := AudioServer.get_bus_index("Sounds")
var music_bus := AudioServer.get_bus_index("Music")

func _ready() -> void:
	if not Variables.has_loaded:
		Variables.load_variables()

	AudioServer.set_bus_volume_db(sounds_bus, linear2db(Variables.stored.volume.sounds))
	AudioServer.set_bus_volume_db(music_bus, linear2db(Variables.stored.volume.music))

func play_music(music_stream: AudioStream) -> void:
	_music_player.stop()
	_music_player.stream = music_stream
	_music_player.play()

func fade_out() -> void:
	var starting_local_volume := db2linear(_music_player.volume_db)
	var current_local_volume := starting_local_volume

	while current_local_volume >= 0:
		current_local_volume -= 0.05
		_music_player.volume_db = linear2db(current_local_volume)
		yield(get_tree().create_timer(0.03), "timeout")

	stop_music()
	emit_signal("faded_out")

	_music_player.volume_db = linear2db(starting_local_volume)

func stop_music() -> void:
	_music_player.stop()
	is_playing_menu_music = false

func play_sound(sound_stream: AudioStream) -> void:
	_sound_player.stop()
	_sound_player.stream = sound_stream
	_sound_player.play()

func _on_MusicPlayer_finished() -> void:
	emit_signal("music_finished")

	if is_playing_menu_music:
		_restart_menu_music_timer.start()

func _on_SoundPlayer_finished() -> void:
	emit_signal("sound_finished")

func play_menu_music() -> void:
	if is_playing_menu_music:
		return

	is_playing_menu_music = true

	randomize()
	play_music(Constants.menu_tracks[randi() % Constants.menu_tracks.size()])

func _on_RestartMenuMusicTimer_timeout() -> void:
	randomize()
	play_music(Constants.menu_tracks[randi() % Constants.menu_tracks.size()])

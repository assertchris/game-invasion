extends Node

signal music_finished
signal sound_finished

onready var _music_player := $MusicPlayer
onready var _sound_player := $SoundPlayer

func play_music(music_stream: AudioStream) -> void:
	_music_player.stop()
	_music_player.stream = music_stream
	_music_player.play()

func stop_music() -> void:
	_music_player.stop()

func play_sound(sound_stream: AudioStream) -> void:
	_sound_player.stop()
	_sound_player.stream = sound_stream
	_sound_player.play()

func _on_MusicPlayer_finished() -> void:
	emit_signal("music_finished")

func _on_SoundPlayer_finished() -> void:
	emit_signal("sound_finished")

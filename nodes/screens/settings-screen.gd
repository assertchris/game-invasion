extends Screen

onready var _music_slider := $Center/Items/MusicVolume/Center/Slider
onready var _sounds_slider := $Center/Items/SoundsVolume/Center/Slider

var sounds_bus = AudioServer.get_bus_index("Sounds")
var music_bus = AudioServer.get_bus_index("Music")

func _ready() -> void:
	_music_slider.value = Variables.stored.volume.music
	_sounds_slider.value = Variables.stored.volume.sounds

func _on_BackButton_pressed() -> void:
	Screens.change_screen(Constants.screens.menu)

func _on_Music_Slider_value_changed(value : float) -> void:
	AudioServer.set_bus_volume_db(music_bus, linear2db(value))
	Variables.stored.volume.music = value
	Variables.save_variables()

func _on_Sounds_Slider_value_changed(value : float) -> void:
	AudioServer.set_bus_volume_db(sounds_bus, linear2db(value))
	Variables.stored.volume.sounds = value
	Variables.save_variables()

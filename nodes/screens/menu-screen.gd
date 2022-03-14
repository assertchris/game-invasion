extends Screen

onready var _continue_button := $Center/Items/ContinueButton
onready var _quit_button := $Center/Items/QuitButton

func _ready() -> void:
	Audio.play_menu_music()

	if OS.has_feature("HTML5"):
		_quit_button.visible = false

func _on_ContinueButton_pressed() -> void:
	Screens.change_screen(Constants.screens.play)

func _on_NewGameButton_pressed() -> void:
	# TODO reset variables
	Screens.change_screen(Constants.screens.play)

func _on_SettingsButton_pressed() -> void:
	Screens.change_screen(Constants.screens.settings)

func _on_CreditsButton_pressed() -> void:
	Screens.change_screen(Constants.screens.credits)

func _on_PatronsButton_pressed() -> void:
	Screens.change_screen(Constants.screens.patrons)

func _on_QuitButton_pressed() -> void:
	get_tree().quit()

func do_hide(_new_screen : int) -> void:
	Audio.fade_out()
	yield(Audio, "faded_out")
	.do_hide(_new_screen)

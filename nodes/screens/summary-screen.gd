extends Screen

func _on_ContinueButton_pressed() -> void:
	Screens.change_screen(Constants.screens.play)

func _on_SaveAndQuitButton_pressed() -> void:
	Screens.change_screen(Constants.screens.menu)

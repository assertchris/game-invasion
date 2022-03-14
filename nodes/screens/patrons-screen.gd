extends Screen

func _on_BackButton_pressed() -> void:
	Screens.change_screen(Constants.screens.menu)

func _on_meta_clicked(meta) -> void:
	OS.shell_open(meta)

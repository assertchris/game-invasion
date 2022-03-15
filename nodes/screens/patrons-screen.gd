extends Screen

func _on_BackButton_pressed() -> void:
	Screens.change_screen(Constants.screens.menu)

func _on_meta_clicked(meta) -> void:
	var _result = OS.shell_open(meta)

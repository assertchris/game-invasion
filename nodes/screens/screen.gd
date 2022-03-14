extends MarginContainer
class_name Screen

signal prepared_to_show
signal prepared_to_hide
signal did_show
signal did_hide

func prepare_to_show() -> void:
	emit_signal("prepared_to_show")

func prepare_to_hide() -> void:
	emit_signal("prepared_to_hide")

func do_show(_new_screen : int) -> void:
	emit_signal("did_show")

func do_hide(_current_screen : int) -> void:
	emit_signal("did_hide")

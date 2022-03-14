extends MarginContainer
class_name Screen

signal prepared_to_show
signal prepared_to_hide
signal did_show
signal did_hide

func prepare_to_show() -> void:
	$Transition/Cover.get_material().set_shader_param("amount", 1.0)
	emit_signal("prepared_to_show")

func prepare_to_hide() -> void:
	$Transition/Cover.get_material().set_shader_param("amount", 0.0)
	emit_signal("prepared_to_hide")

func do_show(_new_screen : int) -> void:
	var current_amount := 0.0

	while current_amount < 1.0:
		current_amount += 0.05
		$Transition/Cover.get_material().set_shader_param("amount", current_amount)
		yield(get_tree().create_timer(0.03), "timeout")

	emit_signal("did_show")

func do_hide(_current_screen : int) -> void:
	var current_amount := 1.0

	while current_amount > 0:
		current_amount -= 0.05
		$Transition/Cover.get_material().set_shader_param("amount", current_amount)
		yield(get_tree().create_timer(0.03), "timeout")

	emit_signal("did_hide")

extends Node

var root = null
var current_screen: int
var current_screen_node: Screen

func _ready() -> void:
	root = get_tree().get_root()
	current_screen_node = root.get_child(root.get_child_count() - 1)
	current_screen_node.call_deferred("prepare_to_show")
	yield(current_screen_node, "prepared_to_show")
	current_screen_node.call_deferred("do_show", Constants.screens.none)

func change_screen(new_screen: int) -> void:
	var new_screen_node : Screen = Constants.screens_scenes[new_screen].instance()
	load_new_screen(new_screen_node, new_screen)

func load_new_screen(new_screen_node: Screen, new_screen: int):
	current_screen_node.call_deferred("prepare_to_hide")
	yield(current_screen_node, "prepared_to_hide")
	new_screen_node.call_deferred("prepare_to_show")
	yield(new_screen_node, "prepared_to_show")

	current_screen_node.call_deferred("do_hide", new_screen)
	yield(current_screen_node, "did_hide")

	current_screen_node.queue_free()
	root.add_child(new_screen_node)

	new_screen_node.call_deferred("do_show", current_screen)
	yield(new_screen_node, "did_show")

	current_screen = new_screen
	current_screen_node = new_screen_node
	OS.hide_virtual_keyboard()

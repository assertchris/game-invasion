extends Doodad

func _on_DrawTimer_timeout() -> void:
	randomize()

	for design in get_tree().get_nodes_in_group("house-designs"):
		if is_a_parent_of(design):
			design.visible = false

	var parent : Node = get_node(str(doodad_size.x) + "x" + str(doodad_size.y))
	parent.get_child(randi() % parent.get_child_count()).visible = true

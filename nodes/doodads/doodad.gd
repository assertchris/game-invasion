extends Area2D
class_name Doodad

var doodad_size : Vector2

func _on_DrawTimer_timeout() -> void:
	if doodad_size:
		print(str(self) + " dimensions: " + str(doodad_size))

extends Node2D
tool

export var color := Color(1.0, 1.0, 1.0, 1.0)
export var radius := 25

func _process(_delta: float) -> void:
	update()

func _draw() -> void:
	draw_circle(position, radius, color)

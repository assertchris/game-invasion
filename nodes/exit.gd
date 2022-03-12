extends Area2D

onready var _collider := $Collider

func disable_collider() -> void:
	_collider.disabled = true

func enable_collider() -> void:
	_collider.disabled = false

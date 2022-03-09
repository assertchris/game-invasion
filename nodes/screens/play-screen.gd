extends Screen

onready var _room := $Center/Room

func _ready() -> void:
	# DEBUG add delay because play is loaded first
	yield(get_tree().create_timer(0.25), "timeout")

	Generation.make_rooms(_room)

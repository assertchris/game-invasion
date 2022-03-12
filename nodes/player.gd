extends KinematicBody2D
class_name Player

onready var _collider := $Collider

var path := PoolVector2Array()

signal position_changed

func _ready():
	set_process(false)

func _process(delta):
	var move_distance = Constants.player_speed * delta
	emit_signal("position_changed", position)
	move_along_path(move_distance)

func disable_collider() -> void:
	_collider.disabled = true

func enable_collider() -> void:
	_collider.disabled = false

func move_along_path(distance):
	var start_point = position

	for _i in range(path.size()):
		var distance_to_next = start_point.distance_to(path[0])

		if distance <= distance_to_next and distance >= 0.0:
			position = start_point.linear_interpolate(path[0], distance / distance_to_next)
			break
		elif distance < 0.0:
			position = path[0]
			set_process(false)
			break

		distance -= distance_to_next
		start_point = path[0]
		path.remove(0)

func set_path(value):
	path = value

	if value.size() == 0:
		return

	set_process(true)

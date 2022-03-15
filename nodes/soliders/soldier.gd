extends StaticBody2D
class_name Soldier

signal acquired
signal captured

onready var _circle := $Circle
onready var _circle_animator := $CircleAnimator
onready var _patrol_timer := $PatrolTimer

var path := PoolVector2Array()
var character : Dictionary
var starting_position : Vector2
var status : int

func _ready():
	set_process(false)

func _process(delta):
	var speed = Constants.soldiers_speed

	if status == Constants.soldiers_statuses.patrolling:
		speed = Constants.soldiers_patrol_speed

	var move_distance = speed * delta

	move_along_path(move_distance)

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

func _on_Proximity_body_entered(body: Node) -> void:
	if not body is Player:
		return

	_circle_animator.play("Show")

func _on_Proximity_body_exited(body: Node) -> void:
	if not body is Player:
		return

	_circle_animator.play_backwards("Show")

func _on_Aquisition_body_entered(body: Node) -> void:
	if not body is Player:
		return

	if status == Constants.soldiers_statuses.captured:
		return

	if status == Constants.soldiers_statuses.following:
		return

	status = Constants.soldiers_statuses.following
	emit_signal("acquired", self)

	_circle_animator.play_backwards("Show")
	yield(_circle_animator, "animation_finished")
	_circle.visible = false

func _on_Capture_body_entered(body: Node) -> void:
	if not body is Player:
		return

	if status == Constants.soldiers_statuses.captured:
		return

	status = Constants.soldiers_statuses.captured
	set_path(PoolVector2Array())

	emit_signal("captured", self)

func _on_PatrolTimer_timeout() -> void:
	if status == Constants.soldiers_statuses.following:
		return

	if status == Constants.soldiers_statuses.captured:
		return

	randomize()

	status = Constants.soldiers_statuses.patrolling

	var room = get_parent().get_parent()

	var coordinates = Vector2(randi() % Constants.tiles_width, randi() % Constants.tiles_width)
	var location = room.layout[coordinates.y][coordinates.x]

	while location != Constants.tiles_types.road:
		coordinates = Vector2(randi() % Constants.tiles_width, randi() % Constants.tiles_width)
		location = room.layout[coordinates.y][coordinates.x]

	var new_position = Vector2(
		coordinates.x * Constants.sprites_width + round(Constants.sprites_width / 2.0),
		coordinates.y * Constants.sprites_width + round(Constants.sprites_width / 2.0)
	)

	var new_path = Variables.current_navigation.get_simple_path(position, new_position, false)
	set_path(new_path)

func reset() -> void:
	set_path(PoolVector2Array())
	position = starting_position
	status = Constants.soldiers_statuses.none
	_circle.visible = true

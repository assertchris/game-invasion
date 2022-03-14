extends StaticBody2D
class_name Survivor

signal acquired
signal rescued

onready var _circle := $Circle
onready var _circle_animator := $CircleAnimator

var path := PoolVector2Array()
var character : Dictionary
var status : int
var was_following := false

func _ready():
	status = Constants.survivors_statuses.none
	set_process(false)

func _process(delta):
	var move_distance = Constants.player_speed * delta
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

func follow(new_path : PoolVector2Array) -> void:
	if status != Constants.survivors_statuses.following:
		return

	set_path(new_path)

func _on_Aquisition_body_entered(body: Node) -> void:
	if not body is Player:
		return

	if was_following:
		return

	was_following = true
	status = Constants.survivors_statuses.following
	emit_signal("acquired", self)

	_circle_animator.play_backwards("Show")
	yield(_circle_animator, "animation_finished")
	_circle.visible = false

func rescue() -> void:
	status = Constants.survivors_statuses.rescued
	visible = false
	emit_signal("rescued", self)

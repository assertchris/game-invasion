extends StaticBody2D
class_name Survivor

onready var _animator := $Animator
onready var _circle := $Circle

var path := PoolVector2Array()
var is_following_player := false

func _ready():
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

	_animator.play("Show")


func _on_Proximity_body_exited(body: Node) -> void:
	if not body is Player:
		return

	_animator.play_backwards("Show")

func _on_Aquisition_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	if not body is Player:
		return

	is_following_player = true

	_animator.play_backwards("Show")
	yield(_animator, "animation_finished")
	_circle.visible = false

func follow(path : PoolVector2Array) -> void:
	if not is_following_player:
		return

	set_path(path)
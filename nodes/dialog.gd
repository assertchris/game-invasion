extends CanvasLayer

onready var _background := $Background
onready var _animator := $Animator

var current_dialog

func _ready() -> void:
	_background.rect_global_position.y = 180

func debug() -> void:
	show()

	current_dialog = Dialogic.start("example-soldier-timeline")
	current_dialog.connect("dialogic_signal", self, "on_dialogic_signal")
	_background.add_child(current_dialog)

func on_dialogic_signal(type : String) -> void:
	if type == "hide":
		hide()

func show() -> void:
	_animator.play("Show")

func hide() -> void:
	_animator.play_backwards("Show")

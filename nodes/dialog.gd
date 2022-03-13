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

func show_acquired_dialog(survivor_character : Dictionary) -> void:
	show()

	current_dialog = Dialogic.start('')
	current_dialog.connect("dialogic_signal", self, "on_dialogic_signal")

	current_dialog.dialog_node.dialog_script = {
		"events":[
			{
				"action": "join",
				"character": survivor_character.file,
				"event_id": "dialogic_002",
				"mirror": false,
				"portrait": "",
				"position": {
					"0": false,
					"1": true,
					"2": false,
					"3": false,
					"4": false
				}
			},
			{
				"character": survivor_character.file,
				"event_id": "dialogic_001",
				"portrait": "",
				"text": "Please help, I am scared"
			},
			{
				"action": "leaveall",
				"character": "[All]",
				"event_id": "dialogic_003"
			},
			{
				"emit_signal": "hide",
				"event_id": "dialogic_040"
			},
		],
	}

	_background.add_child(current_dialog)

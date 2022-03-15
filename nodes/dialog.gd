extends CanvasLayer

onready var _background := $Background
onready var _animator := $Animator

var current_dialog

const acquire_survivor_lines := [
	"Please help, I am scared",
	"Do you know the way to the hospital?",
	"I heard fighting to the east",
	"Are you...are you friendly?",
]

const rescued_survivor_lines := [
	"I don't know how to thank you",
	"You are a good person",
	"I wonder if my parents are here",
	"We made it just in time",
	"I can breathe, now",
]

const captured_soldier_lines := [
	"What are you doing here? Come with me",
	"Where do you think you're going?",
	"I have orders to take you in",
	"Don't make this difficult",
	"Have I seen you before?",
]

const captured_survivor_lines := [
	"Please don't hurt me",
	"I will comply",
	"Can I bring my things?",
	"Where are you taking me?",
	"I don't want to get hurt",
]

const pleeding_survivor_lines := [
	"You can't leave me here",
	"Where will I go?",
	"I don't think it's safe here",
	"What am I supposed to do now?",
	"Did I say something wrong?",
]

const harassing_soldier_lines := [
	"If I see you again I'll shoot you",
	"Get the hell out of here",
	"Leave now!",
	"You're nothing",
	"I hate your kind",
]

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
	randomize()

	show()

	current_dialog = Dialogic.start("")
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
					"4": false,
				}
			},
			{
				"character": survivor_character.file,
				"event_id": "dialogic_001",
				"portrait": "",
				"text": acquire_survivor_lines[randi() % acquire_survivor_lines.size()],
			},
			{
				"action": "leaveall",
				"character": "[All]",
				"event_id": "dialogic_003",
			},
			{
				"emit_signal": "hide",
				"event_id": "dialogic_040",
			},
		],
	}

	_background.add_child(current_dialog)

func show_rescued_dialog(survivor_character : Dictionary) -> void:
	randomize()

	show()

	current_dialog = Dialogic.start("")
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
					"4": false,
				}
			},
			{
				"character": survivor_character.file,
				"event_id": "dialogic_001",
				"portrait": "",
				"text": rescued_survivor_lines[randi() % rescued_survivor_lines.size()],
			},
			{
				"action": "leaveall",
				"character": "[All]",
				"event_id": "dialogic_003",
			},
			{
				"emit_signal": "hide",
				"event_id": "dialogic_040",
			},
		],
	}

	_background.add_child(current_dialog)

func show_captured_dialog(survivor_character : Dictionary, soldier_character : Dictionary) -> void:
	randomize()

	show()

	current_dialog = Dialogic.start("")
	current_dialog.connect("dialogic_signal", self, "on_dialogic_signal")

	current_dialog.dialog_node.dialog_script = {
		"events":[
			{
				"action": "join",
				"character": soldier_character.file,
				"event_id": "dialogic_002",
				"mirror": false,
				"portrait": "",
				"position": {
					"0": false,
					"1": false,
					"2": false,
					"3": true,
					"4": false
				}
			},
			{
				"character": soldier_character.file,
				"event_id": "dialogic_001",
				"portrait": "",
				"text": captured_soldier_lines[randi() % captured_soldier_lines.size()],
			},
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
				"text": captured_survivor_lines[randi() % captured_survivor_lines.size()],
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

func show_harass_dialog(soldier_character : Dictionary) -> void:
	randomize()

	show()

	current_dialog = Dialogic.start("")
	current_dialog.connect("dialogic_signal", self, "on_dialogic_signal")

	current_dialog.dialog_node.dialog_script = {
		"events":[
			{
				"action": "join",
				"character": soldier_character.file,
				"event_id": "dialogic_002",
				"mirror": false,
				"portrait": "",
				"position": {
					"0": false,
					"1": false,
					"2": false,
					"3": true,
					"4": false
				}
			},
			{
				"character": soldier_character.file,
				"event_id": "dialogic_001",
				"portrait": "",
				"text": harassing_soldier_lines[randi() % harassing_soldier_lines.size()],
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

func show_pleed_dialog(survivor_character : Dictionary) -> void:
	randomize()

	show()

	current_dialog = Dialogic.start("")
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
				"text": pleeding_survivor_lines[randi() % pleeding_survivor_lines.size()],
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

extends Screen

onready var _hope := $Center/Items/Hope
onready var _rescued := $Center/Items/Rescued

func _ready() -> void:
	_hope.bbcode_text = "[center]Hope: " + str(Variables.stored.hope) + "[/center]"
	_rescued.bbcode_text = "[center]Rescued: " + str(Variables.stored.rescued) + "[/center]"

func _on_ContinueButton_pressed() -> void:
	Screens.change_screen(Constants.screens.play)

func _on_SaveAndQuitButton_pressed() -> void:
	Variables.force_save_variables()
	Screens.change_screen(Constants.screens.menu)

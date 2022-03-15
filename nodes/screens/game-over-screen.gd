extends Screen

onready var _rescued := $Center/Items/Rescued

func _ready() -> void:
	_rescued.bbcode_text = "[center]You managed to rescue " + str(Variables.stored.rescued) + " survivors.[/center][center]The world is a better place because of your kindness.[/center]"

func _on_QuitToMenuButton_pressed() -> void:
	Variables.reset()
	Screens.change_screen(Constants.screens.menu)

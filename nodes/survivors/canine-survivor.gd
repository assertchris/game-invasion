extends Survivor

export (AudioStream) var bork_sound

onready var _bork := $Bork

func _ready() -> void:
	_bork.visible = false

func _on_CanineSurvivor_acquired(_survivor : Survivor) -> void:
	Audio.play_sound(bork_sound)

	_bork.visible = true
	yield(get_tree().create_timer(1.0), "timeout")
	_bork.visible = false

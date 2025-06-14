extends Control
class_name ArenaResults

signal continue_pressed

func _ready() -> void:
	size = get_viewport_rect().size


func set_results(params: Dictionary) -> void:
	if params["result"] == "victory":
		$VBoxContainer/VictoryLabel.visible = true
		$VBoxContainer/DefeatLabel.visible = false
	else:
		$VBoxContainer/VictoryLabel.visible = false
		$VBoxContainer/DefeatLabel.visible = true
	$VBoxContainer/DifficultyLabel.text = params["difficulty"]
	$VBoxContainer/HBoxContainer/TimeValue.text = "%03d" % params["time"]
	$VBoxContainer/HBoxContainer2/GradeValue.text = params["grade"]
	$VBoxContainer/ClearedArenasLabel.text = "Arenas %d" % params["arenas_completed"]


func _on_button_pressed() -> void:
	continue_pressed.emit()

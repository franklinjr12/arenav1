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
	$VBoxContainer/PlayerDamagedLabel.text = "Damage taken %d" % params["player_damage_taken"]
	$VBoxContainer/EnemyDamagedLabel.text = "Damage given %d" % params["enemies_damage_taken"]
	$VBoxContainer/KillsLabel.text = "Kills %d" % params["kills"]


func _on_button_pressed() -> void:
	continue_pressed.emit()

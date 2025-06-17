class_name ArenaFightsCompleted
extends Control

signal continue_pressed

var fights_completed: int = 0
var fights_results: Array[Dictionary] = []

func _ready() -> void:
	size = get_viewport().size
	$VBoxContainer/ContinueButton.pressed.connect(_on_continue_button_pressed)


func set_fights_completed(number: int) -> void:
	fights_completed = number
	$VBoxContainer/Label.text = "You completed all {0} fights!!!".format([fights_completed])


func set_results(results: Array[Dictionary]) -> void:
	fights_results = results
	fights_completed = fights_results.size()
	set_fights_completed(fights_completed)
	var results_text: String = ""
	var total_time: int = 0
	var total_kills: int = 0
	var total_damage_given: int = 0
	var total_damage_taken: int = 0
	var total_arenas: int = 0
	var total_experience: int = 0
	for r in fights_results:
		results_text += str(r) + "\n"
		total_time += r["time"]
		total_kills += r["kills"]
		total_damage_given += r["enemies_damage_taken"]
		total_damage_taken += r["player_damage_taken"]
		total_experience += r["player_experience_gained"]
		total_arenas += 1
	$VBoxContainer/ResultsLabel.text = str(results_text)
	$VBoxContainer/TotalTimeLabel.text = "Total fight time %ds" % total_time
	$VBoxContainer/TotalKillsLabel.text = "Total kills %d" % total_kills
	$VBoxContainer/TotalDamageGivenLabel.text = "Total damage given %d" % total_damage_given
	$VBoxContainer/TotalDamageTakenLabel.text = "Total damage taken %d" % total_damage_taken
	$VBoxContainer/TotalArenasLabel.text = "Total arenas %d" % total_arenas
	$VBoxContainer/TotalExperience.text = "Total experience %d" % total_experience


func _on_continue_button_pressed() -> void:
	continue_pressed.emit()

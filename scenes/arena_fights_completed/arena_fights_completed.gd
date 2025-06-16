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
	for r in fights_results:
		results_text += str(r) + "\n"
	$VBoxContainer/ResultsLabel.text = str(results_text)


func _on_continue_button_pressed() -> void:
	continue_pressed.emit()

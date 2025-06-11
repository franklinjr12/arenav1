extends Node2D

signal difficulty_selected

enum Difficulty {EASY, MEDIUM, HARD}

func _ready() -> void:
	get_tree().get_first_node_in_group("EasyButton").pressed.connect(_on_easy_button_pressed)
	get_tree().get_first_node_in_group("MediumButton").pressed.connect(_on_medium_button_pressed)
	get_tree().get_first_node_in_group("HardButton").pressed.connect(_on_hard_button_pressed)


func _on_easy_button_pressed() -> void:
	difficulty_selected.emit(Difficulty.EASY)


func _on_medium_button_pressed() -> void:
	difficulty_selected.emit(Difficulty.MEDIUM)


func _on_hard_button_pressed() -> void:
	difficulty_selected.emit(Difficulty.HARD)

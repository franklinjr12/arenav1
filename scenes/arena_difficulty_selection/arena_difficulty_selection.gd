extends Control

signal difficulty_selected

enum Difficulty {EASY, MEDIUM, HARD}

func _ready() -> void:
	size = get_viewport_rect().size
	get_tree().get_first_node_in_group("EasyButton").pressed.connect(_on_easy_button_pressed)
	get_tree().get_first_node_in_group("MediumButton").pressed.connect(_on_medium_button_pressed)
	get_tree().get_first_node_in_group("HardButton").pressed.connect(_on_hard_button_pressed)


func _on_easy_button_pressed() -> void:
	difficulty_selected.emit("easy")


func _on_medium_button_pressed() -> void:
	difficulty_selected.emit("medium")


func _on_hard_button_pressed() -> void:
	difficulty_selected.emit("hard")

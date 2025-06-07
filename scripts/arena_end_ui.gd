extends Control

signal retry_button_clicked

func victory():
	$VBoxContainer/GameStatusLabel.text = "Victory"


func defeat():
	$VBoxContainer/GameStatusLabel.text = "Defeat"


func set_grade(grade: String) -> void:
	$VBoxContainer/HBoxContainer/GradeValue.text = grade.to_upper()


func _on_retry_button_pressed() -> void:
	retry_button_clicked.emit()

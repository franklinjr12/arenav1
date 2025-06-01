extends Control

signal retry_button_clicked

func victory():
	$VBoxContainer/GameStatusLabel.text = "Victory"


func defeat():
	$VBoxContainer/GameStatusLabel.text = "Defeat"


func _on_retry_button_pressed() -> void:
	retry_button_clicked.emit()

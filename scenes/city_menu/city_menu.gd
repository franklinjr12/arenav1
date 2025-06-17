extends Control

@onready var character_sheet_scene: PackedScene = preload("res://scenes/player_character_screen/player_character_screen.tscn")

func _ready() -> void:
	size = get_viewport().size


func _on_arena_button_pressed() -> void:
	get_parent().create_difficulty_screen()
	queue_free()


func _on_quit_button_pressed() -> void:
	# get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()


func _on_character_sheet_button_pressed() -> void:
	get_parent().create_player_character_screen()
	queue_free()

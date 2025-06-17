extends Control

signal continue_pressed

var player: Player = null
var level_up_node = null

func _ready() -> void:
	size = get_viewport().size
	level_up_node = $CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer2/PlayerLevelUp
	level_up_node.hide_continue_button()
	level_up_node.set_player_stats(player.get_node("PlayerStats"))


func _on_continue_button_pressed() -> void:
	continue_pressed.emit()

extends Control

signal continue_pressed

var player: Player = null
var level_up_node = null

func _ready() -> void:
	size = get_viewport().size
	level_up_node = $CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer2/PlayerLevelUp
	level_up_node.hide_continue_button()
	level_up_node.set_player_stats(player.get_node("PlayerStats"))
	player.gold_changed.connect(on_player_gold_changed)
	player.health_changed.connect(on_player_health_changed)
	$CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/HealPlayerButton.player = player
	set_labels()


func set_labels() -> void:
	var stats: PlayerStats = player.get_node("PlayerStats")
	$CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/PlayerHealthLabel.text = "Health {0}/{1}".format([stats.health_points, stats.max_health_points])
	$CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/PlayerLevelLabel.text = "Level %d" % stats.level
	$CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/PlayerExperienceLabel.text = "Experience %d" % stats.experience_points
	$CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/PlayerGoldLabel.text = "Gold %d" % stats.gold


func on_player_gold_changed(gold: int) -> void:
	$CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/PlayerGoldLabel.text = "Gold %d" % gold


func on_player_health_changed(_current_health: int) -> void:
	var stats: PlayerStats = player.get_node("PlayerStats")
	$CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/PlayerHealthLabel.text = "Health {0}/{1}".format([stats.health_points, stats.max_health_points])


func _on_continue_button_pressed() -> void:
	continue_pressed.emit()

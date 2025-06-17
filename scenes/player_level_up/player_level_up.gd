extends Control

signal continue_pressed

var player_stats: PlayerStats = null

func _ready() -> void:
	if player_stats == null:
		return
	set_player_stats(player_stats)


func set_player_stats(stats: PlayerStats) -> void:
	player_stats = stats
	$VBoxContainer/HBoxContainer/IntelligenceValue.text = str(player_stats.intelligence)
	$VBoxContainer/HBoxContainer/IntelligenceButton.pressed.connect(on_intelligence_button)
	$VBoxContainer/HBoxContainer2/DexterityValue.text = str(player_stats.dexterity)
	$VBoxContainer/HBoxContainer2/DexterityButton.pressed.connect(on_dexterity_button)
	$VBoxContainer/HBoxContainer3/SwiftnessValue.text = str(player_stats.swiftness)
	$VBoxContainer/HBoxContainer3/SwiftnessButton.pressed.connect(on_swiftness_button)
	$VBoxContainer/HBoxContainer4/VitalityValue.text = str(player_stats.vitality)
	$VBoxContainer/HBoxContainer4/VitalityButton.pressed.connect(on_vitality_button)
	$VBoxContainer/HBoxContainer5/LuckValue.text = str(player_stats.luck)
	$VBoxContainer/HBoxContainer5/LuckButton.pressed.connect(on_luck_button)
	$VBoxContainer/AvailableAttributePointsLabel.text = "Available points %d" % player_stats.available_attribute_points


func hide_continue_button() -> void:
	$VBoxContainer/ContinueButton.visible = false


func on_intelligence_button() -> void:
	if player_stats.available_attribute_points > 0:
		player_stats.available_attribute_points -= 1
		player_stats.intelligence += 1
		$VBoxContainer/HBoxContainer/IntelligenceValue.text = str(player_stats.intelligence)
		$VBoxContainer/AvailableAttributePointsLabel.text = "Available points %d" % player_stats.available_attribute_points


func on_dexterity_button() -> void:
	if player_stats.available_attribute_points > 0:
		player_stats.available_attribute_points -= 1
		player_stats.dexterity += 1
		$VBoxContainer/HBoxContainer2/DexterityValue.text = str(player_stats.dexterity)
		$VBoxContainer/AvailableAttributePointsLabel.text = "Available points %d" % player_stats.available_attribute_points


func on_swiftness_button() -> void:
	if player_stats.available_attribute_points > 0:
		player_stats.available_attribute_points -= 1
		player_stats.swiftness += 1
		$VBoxContainer/HBoxContainer3/SwiftnessValue.text = str(player_stats.swiftness)
		$VBoxContainer/AvailableAttributePointsLabel.text = "Available points %d" % player_stats.available_attribute_points


func on_vitality_button() -> void:
	if player_stats.available_attribute_points > 0:
		player_stats.available_attribute_points -= 1
		player_stats.vitality += 1
		$VBoxContainer/HBoxContainer4/VitalityValue.text = str(player_stats.vitality)
		$VBoxContainer/AvailableAttributePointsLabel.text = "Available points %d" % player_stats.available_attribute_points


func on_luck_button() -> void:
	if player_stats.available_attribute_points > 0:
		player_stats.available_attribute_points -= 1
		player_stats.luck += 1
		$VBoxContainer/HBoxContainer5/LuckValue.text = str(player_stats.luck)
		$VBoxContainer/AvailableAttributePointsLabel.text = "Available points %d" % player_stats.available_attribute_points


func _on_continue_button_pressed() -> void:
	continue_pressed.emit()

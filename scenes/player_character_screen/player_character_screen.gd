extends Control

signal continue_pressed

@onready var acquired_skill_button_scene = preload("res://scenes/player_character_screen/acquired_skill_button.tscn")

var player: Player = null
var level_up_node = null
var pressed_spell: PackedScene = null

func _ready() -> void:
	size = get_viewport().size
	level_up_node = $CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer2/PlayerLevelUp
	level_up_node.hide_continue_button()
	level_up_node.set_player_stats(player.get_node("PlayerStats"))
	player.gold_changed.connect(on_player_gold_changed)
	player.health_changed.connect(on_player_health_changed)
	$CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/HealPlayerButton.player = player
	set_labels()
	var container = $CenterContainer/VBoxContainer/HBoxContainer/AcquiredSpellContainer
	for spell in player.acquired_spells:
		var new_button = acquired_skill_button_scene.instantiate()
		new_button.spell_scene = spell
		new_button.spell_pressed.connect(_on_acquired_spell_pressed)
		container.add_child(new_button)
	$CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/SkillQ.set_spell_scene(player.get_action("Q"))
	$CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/SkillW.set_spell_scene(player.get_action("W"))
	$CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/SkillE.set_spell_scene(player.get_action("E"))
	$CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/SkillR.set_spell_scene(player.get_action("R"))


func _process(delta: float) -> void:
	if pressed_spell == null:
		return
	# TODO should only assign if the spell is not equiped yet
	if Input.is_action_pressed("q_action"):
		player.set_action("Q", pressed_spell)
		$CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/SkillQ.set_spell_scene(pressed_spell)
	if Input.is_action_pressed("w_action"):
		player.set_action("W", pressed_spell)
		$CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/SkillW.set_spell_scene(pressed_spell)
	if Input.is_action_pressed("e_action"):
		player.set_action("E", pressed_spell)
		$CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/SkillE.set_spell_scene(pressed_spell)
	if Input.is_action_pressed("r_action"):
		player.set_action("R", pressed_spell)
		$CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/SkillR.set_spell_scene(pressed_spell)


func set_labels() -> void:
	var stats: PlayerStats = player.get_node("PlayerStats")
	$CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/PlayerHealthLabel.text = "Health {0}/{1}".format([stats.health_points, stats.max_health_points])
	$CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/PlayerLevelLabel.text = "Level %d" % stats.level
	$CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/PlayerExperienceLabel.text = "Experience %d / %d" % [stats.experience_points, stats.get_experience_for_next_level()]
	$CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/PlayerGoldLabel.text = "Gold %d" % stats.gold


func on_player_gold_changed(gold: int) -> void:
	$CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/PlayerGoldLabel.text = "Gold %d" % gold


func on_player_health_changed(_current_health: int) -> void:
	var stats: PlayerStats = player.get_node("PlayerStats")
	$CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/PlayerHealthLabel.text = "Health {0}/{1}".format([stats.health_points, stats.max_health_points])


func _on_continue_button_pressed() -> void:
	continue_pressed.emit()


func _on_acquired_spell_pressed(params: Dictionary) -> void:
	pressed_spell = params["spell"]

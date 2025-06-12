extends Node2D
class_name Arena

@export var enemies_difficulty: EnemiesDifficultyResource

@onready var enemy_rat = preload("res://scenes/enemies/rat/enemy_rat.tscn")
@onready var enemy_caster = preload("res://scenes/enemies/caster/enemy_caster.tscn")
@onready var enemy_brawler = preload("res://scenes/enemies/brawler/enemy_brawler.tscn")
# @onready var player = preload("res://scenes/player/player.tscn")

var current_enemies_count: int = 0
var current_arena_time: int = 0
var player_died: bool = false
var player_inst: Player = null
var difficulty: String

func _ready() -> void:
	reset_enemies()
	connect_player()
	connect_enemies()
	var retry_button = get_node_or_null("ArenaCamera/ArenaEndUi")
	if retry_button != null:
		retry_button.retry_button_clicked.connect(on_retry_button)
	set_combat_time(current_arena_time)


func set_combat_time(time: int) -> void:
	var formatted_string = "%03d" % time
	get_tree().get_first_node_in_group("ArenaTime").text = formatted_string


func connect_player():
	var p: Player = get_player()
	if !p.died.is_connected(on_player_died):
		p.died.connect(on_player_died)


func connect_enemies():
	var enemies = get_tree().get_nodes_in_group("Enemy")
	current_enemies_count = enemies.size()
	for e in enemies:
		if !e.died.is_connected(on_enemies_died):
			e.died.connect(on_enemies_died)


func add_player(p: Player) -> void:
	p.position = $PlayerSpawn.position
	add_child(p)


func get_player() -> Player:
	var p = get_tree().get_first_node_in_group("Player")
	if p == null:
		p = player_inst
	return p


func set_difficulty(option: String):
	difficulty = option

func show_arena_end():
	var player: Player = get_player()
	var test_label: Label = get_tree().get_first_node_in_group("TestLabel")
	test_label.visible = true
	test_label.text = "Exp: {0}\nLevel: {1}".format([player.get_experience(), player.get_level()])
	var ui = get_tree().get_first_node_in_group("ArenaEndUi")
	if ui != null:
		ui.set_grade(completion_grade())
		if player_died:
			ui.defeat()
		else:
			ui.victory()
		ui.visible = true


func reset_arena():
	var test_label: Label = get_tree().get_first_node_in_group("TestLabel")
	test_label.visible = false
	var ui = get_tree().get_first_node_in_group("ArenaEndUi")
	if ui != null:
		ui.visible = false
	reset_enemies()
	reset_player()
	current_arena_time = 0
	player_died = false


func reset_player():
	var current_player: Player = get_player()
	if current_player != null:
		remove_child(current_player)
	if current_player == null:
		current_player = player_inst
	add_child(current_player)
	current_player.position = $PlayerSpawn.position
	if player_died:
		current_player.set_initial_values()
	connect_player()


func reset_enemies():
	var enemies = get_tree().get_nodes_in_group("Enemy")
	for e in enemies:
		e.free()
	if difficulty == "":
		difficulty = "easy"
	var selection: Array = enemies_difficulty.enemies_spawn[difficulty]
	var spawn_counter: int = 1
	for s in selection:
		var n = get_node_or_null("EnemySpawn"+str(spawn_counter))
		if n != null:
			var enemy = s.instantiate()
			enemy.position = n.position
			add_child(enemy)
			spawn_counter += 1
	connect_enemies()


func on_player_died():
	player_died = true
	player_inst = get_player()
	remove_child(player_inst)
	show_arena_end()


func on_enemies_died(param: Dictionary):
	if param != null:
		if param.has("experience"):
			var drop_exp:int = param["experience"]
			get_player().gain_experience(drop_exp)
	current_enemies_count -= 1
	if current_enemies_count == 0:
		show_arena_end()


func on_retry_button():
	reset_arena()


func _on_combat_timer_timeout() -> void:
	current_arena_time += 1
	set_combat_time(current_arena_time)


func completion_grade() -> String:
	if player_died:
		return "F"
	var time: int = current_arena_time
	if time < 30:
		return "A"
	if time < 60:
		return "B"
	if time < 130:
		return "C"
	if time < 160:
		return "D"
	if time < 190:
		return "E"
	return "F"

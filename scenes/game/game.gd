extends Node2D

@onready var player: Player = preload("res://scenes/player/player.tscn").instantiate()

@onready var arena_scene: PackedScene = preload("res://scenes/arena/arena.tscn")
@onready var arena_difficulty_scene: PackedScene = preload("res://scenes/arena_difficulty_selection/arena_difficulty_selection.tscn")
@onready var arena_results_scene: PackedScene = preload("res://scenes/arena_results/arena_results.tscn")

const ARENA_FIGHTS_TO_PROCEED: int = 3

var arena_difficulty_option: String
var player_died: bool = false
var arena_fights_completed: int = 0
var arena_results_array: Array[Dictionary] = []
var player_levelled_up: bool = false

func _ready() -> void:
	create_difficulty_screen()
	player.died.connect(on_player_died)
	player.levelled_up.connect(on_player_level_up)


func create_arena(difficulty: String) -> void:
	var arena: Arena = arena_scene.instantiate()
	arena.set_difficulty(difficulty)
	arena.add_player(player)
	if player_died:
		player.set_initial_values()
		player_died = false
	arena.combat_ended.connect(on_arena_ended)
	add_child(arena)


func create_difficulty_screen() -> void:
	var difficulty_inst = arena_difficulty_scene.instantiate()
	difficulty_inst.difficulty_selected.connect(on_difficulty_selected)
	add_child(difficulty_inst)


func create_arena_results_screen(params: Dictionary) -> void:
	var results_inst: ArenaResults = arena_results_scene.instantiate()
	results_inst.set_results(params)
	results_inst.continue_pressed.connect(on_results_continue_pressed)
	add_child(results_inst)


func create_fights_completed_screen() -> void:
	var scene: PackedScene = load("res://scenes/arena_fights_completed/arena_fights_completed.tscn")
	var fights_completed: ArenaFightsCompleted = scene.instantiate()
	fights_completed.set_results(arena_results_array)
	fights_completed.continue_pressed.connect(on_arena_fights_completed_continue)
	add_child(fights_completed)


func create_player_level_up_screen() -> void:
	var scene: PackedScene = load("res://scenes/player_level_up/player_level_up.tscn")
	var level_up_screen = scene.instantiate()
	level_up_screen.player_stats = player.get_node("PlayerStats")
	level_up_screen.continue_pressed.connect(on_player_level_up_continue_pressed)
	add_child(level_up_screen)


func on_arena_ended(params: Dictionary):
	arena_fights_completed += 1
	params["arenas_completed"] = arena_fights_completed
	var arena: Arena = get_tree().get_first_node_in_group("Arena")
	if arena != null:
		var n: Node = arena.get_node(NodePath(player.name))
		if n != null:
			arena.remove_child(player)
		arena.queue_free()
	arena_results_array.append(params)
	if arena_fights_completed >= ARENA_FIGHTS_TO_PROCEED:
		create_fights_completed_screen()
	else:
		create_arena_results_screen(params)


func on_arena_fights_completed_continue() -> void:
	arena_fights_completed = 0
	arena_results_array = []
	var n: Node = get_tree().get_first_node_in_group("ArenaFightsCompleted")
	if n != null:
		remove_child(n)
	if player_levelled_up:
		player_levelled_up = false
		create_player_level_up_screen()
	else:
		create_difficulty_screen()


func on_difficulty_selected(option: String):
	arena_difficulty_option = option
	var node = get_tree().get_first_node_in_group("ArenaDifficultyUi")
	if node != null:
		remove_child(node)
		node.queue_free()
	create_arena(option)


func on_player_died() -> void:
	player_died = true


func on_player_level_up() -> void:
	player_levelled_up = true


func on_player_level_up_continue_pressed() -> void:
	var node = get_tree().get_first_node_in_group("PlayerLevelUp")
	if node != null:
		remove_child(node)
		node.queue_free()
	create_difficulty_screen()

func on_results_continue_pressed() -> void:
	var node = get_tree().get_first_node_in_group("ArenaResults")
	if node != null:
		remove_child(node)
		node.queue_free()
	create_difficulty_screen()

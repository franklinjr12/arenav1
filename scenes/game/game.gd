extends Node2D

@onready var player: Player = preload("res://scenes/player/player.tscn").instantiate()

@onready var arena_scene: PackedScene = preload("res://scenes/arena/arena.tscn")
@onready var arena_difficulty_scene: PackedScene = preload("res://scenes/arena_difficulty_selection/arena_difficulty_selection.tscn")
@onready var arena_results_scene: PackedScene = preload("res://scenes/arena_results/arena_results.tscn")

var arena_difficulty_option: String

func _ready() -> void:
	create_difficulty_screen()


func create_arena(difficulty: String) -> void:
	var arena: Arena = arena_scene.instantiate()
	arena.set_difficulty(difficulty)
	arena.add_player(player)
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


func on_arena_ended(params: Dictionary):
	var arena: Arena = get_tree().get_first_node_in_group("Arena")
	if arena != null:
		arena.remove_child(player)
		arena.queue_free()
	create_arena_results_screen(params)


func on_difficulty_selected(option: String):
	arena_difficulty_option = option
	var node = get_tree().get_first_node_in_group("ArenaDifficultyUi")
	if node != null:
		remove_child(node)
		node.queue_free()
	create_arena(option)


func on_results_continue_pressed() -> void:
	var node = get_tree().get_first_node_in_group("ArenaResults")
	if node != null:
		remove_child(node)
		node.queue_free()
	create_difficulty_screen()

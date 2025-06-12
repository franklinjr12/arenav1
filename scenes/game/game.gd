extends Node2D

@onready var player: Player = preload("res://scenes/player/player.tscn").instantiate()

@onready var arena_scene: PackedScene = preload("res://scenes/arena/arena.tscn")
@onready var arena_difficulty_scene: PackedScene = preload("res://scenes/arena_difficulty_selection/arena_difficulty_selection.tscn")

var arena_difficulty_option: String

func _ready() -> void:
	create_difficulty_screen()


func create_arena(difficulty: String) -> void:
	var arena: Arena = arena_scene.instantiate()
	arena.set_difficulty(difficulty)
	arena.add_player(player)
	add_child(arena)


func create_difficulty_screen() -> void:
	var difficulty_inst = arena_difficulty_scene.instantiate()
	# TODO fix for screen resizing
	difficulty_inst.size = get_viewport_rect().size
	difficulty_inst.difficulty_selected.connect(on_difficulty_selected)
	add_child(difficulty_inst)


func on_difficulty_selected(option: String):
	arena_difficulty_option = option
	var node = get_tree().get_first_node_in_group("ArenaDifficultyUi")
	if node != null:
		remove_child(node)
	create_arena(option)

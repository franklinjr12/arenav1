extends Node2D
class_name Game

@onready var enemy = preload("res://scenes/enemy.tscn")
@onready var player = preload("res://scenes/player.tscn")

var current_enemies_count: int = 0

func _ready() -> void:
	connect_player()
	connect_enemies()
	var retry_button = get_node_or_null("ArenaCamera/ArenaEndUi")
	if retry_button != null:
		retry_button.retry_button_clicked.connect(on_retry_button)

func connect_player():
	get_tree().get_first_node_in_group("player").died.connect(on_player_died)


func connect_enemies():
	var enemies = get_tree().get_nodes_in_group("Enemy")
	current_enemies_count = enemies.size()
	for e in enemies:
		e.died.connect(on_enemies_died)


func show_arena_end():
	var ui = get_node_or_null("ArenaCamera/ArenaEndUi")
	if ui != null:
		ui.victory()
		ui.visible = true


func reset_arena():
	var ui = get_node_or_null("ArenaCamera/ArenaEndUi")
	if ui != null:
		ui.visible = false
	reset_enemies()
	reset_player()


func reset_player():
	# TODO do not delete the player
	# Instead just remove from scene and handle appropriatly
	var current_player = get_tree().get_first_node_in_group("player")
	if current_player != null:
		current_player.free()
	var player_inst = player.instantiate()
	player_inst.position = $PlayerSpawn.position
	add_child(player_inst)
	connect_player()


func reset_enemies():
	var enemies = get_tree().get_nodes_in_group("Enemy")
	for e in enemies:
		e.free()
	var enemy_inst = enemy.instantiate()
	enemy_inst.position = $EnemySpawn.position
	add_child(enemy_inst)
	connect_enemies()


func on_player_died():
	var ui = get_node_or_null("ArenaCamera/ArenaEndUi")
	if ui != null:
		ui.defeat()
		ui.visible = true


func on_enemies_died():
	current_enemies_count -= 1
	if current_enemies_count == 0:
		show_arena_end()


func on_retry_button():
	reset_arena()

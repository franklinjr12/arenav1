extends Node2D
class_name Arena

@onready var enemy = null
@onready var player = preload("res://scenes/player.tscn")

var current_enemies_count: int = 0
var current_arena_time: int = 0

func _ready() -> void:
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
	get_tree().get_first_node_in_group("player").died.connect(on_player_died)


func connect_enemies():
	var enemies = get_tree().get_nodes_in_group("Enemy")
	current_enemies_count = enemies.size()
	for e in enemies:
		e.died.connect(on_enemies_died)


func show_arena_end():
	var ui = get_tree().get_first_node_in_group("ArenaEndUi")
	if ui != null:
		ui.set_grade(completion_grade())
		ui.victory()
		ui.visible = true


func reset_arena():
	var ui = get_tree().get_first_node_in_group("ArenaEndUi")
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
	#var enemy_inst = enemy.instantiate()
	#enemy_inst.position = $EnemySpawn.position
	#add_child(enemy_inst)
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


func _on_combat_timer_timeout() -> void:
	current_arena_time += 1
	set_combat_time(current_arena_time)


func completion_grade() -> String:
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

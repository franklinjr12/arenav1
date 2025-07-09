extends Node2D
class_name Arena

signal combat_ended

@export var enemies_difficulty: EnemiesDifficultyResource

@onready var enemy_rat = preload("res://scenes/enemies/rat/enemy_rat.tscn")
@onready var enemy_caster = preload("res://scenes/enemies/caster/enemy_caster.tscn")
@onready var enemy_brawler = preload("res://scenes/enemies/brawler/enemy_brawler.tscn")

var current_enemies_count: int = 0
var current_arena_time: int = 0
var player_died: bool = false
var player_inst: Player = null
var difficulty: String
var kills: int = 0
var player_damage_taken: float = 0
var enemies_damage_taken: float = 0
var player_experience_gained: float = 0
var gold_to_gain: int = 0

const grade_reward_multiplier: Dictionary = {
	"A": 2.0,
	"B": 1.5,
	"C": 1.0,
	"D": 0.5,
	"E": 0.25,
	"F": 0.1
}

func _ready() -> void:
	reset_enemies()
	connect_player()
	connect_enemies()
	set_combat_time(current_arena_time)


func set_combat_time(time: int) -> void:
	var formatted_string = "%03d" % time
	get_tree().get_first_node_in_group("ArenaTime").text = formatted_string


func connect_player():
	var p: Player = get_player()
	if !p.died.is_connected(on_player_died):
		p.died.connect(on_player_died)
	if !p.damaged.is_connected(on_player_damaged):
		p.damaged.connect(on_player_damaged)


func connect_enemies():
	var enemies = get_tree().get_nodes_in_group("Enemy")
	current_enemies_count = enemies.size()
	print("enemies count %d" % current_enemies_count)
	for e in enemies:
		if !e.died.is_connected(on_enemies_died):
			e.died.connect(on_enemies_died)
		if !e.damaged.is_connected(on_enemy_damaged):
			e.damaged.connect(on_enemy_damaged)


func add_player(p: Player) -> void:
	p.position = $PlayerSpawn.position
	p.is_invulnerable = false
	player_inst = p
	add_child(p)


func get_player() -> Player:
	var p = get_tree().get_first_node_in_group("Player")
	if p == null:
		p = player_inst
	return p


func set_difficulty(option: String):
	difficulty = option


func show_arena_end():
	# TODO add some timer for arena not to end instantaneously
	var player: Player = get_player()
	player.is_invulnerable = true
	var grade = completion_grade()
	var params: Dictionary = {
		"result": "defeat" if player_died else "victory",
		"time": current_arena_time,
		"grade": grade,
		"difficulty": difficulty,
		"kills": kills,
		"player_damage_taken": player_damage_taken,
		"enemies_damage_taken": enemies_damage_taken,
		"player_experience_gained": player_experience_gained * grade_reward_multiplier[grade],
		"gold": gold_to_gain * grade_reward_multiplier[grade]
	}
	combat_ended.emit(params)


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
		difficulty = "easy" # setting a default value
	var enemies_setup: Dictionary = enemies_difficulty.get_enemies_spawn_setup()
	var selection: Array = enemies_setup[difficulty]["enemy_pool"]
	var min_spawn: int = enemies_setup[difficulty]["min_spawn"]
	var max_spawn: int = enemies_setup[difficulty]["max_spawn"]
	var amount_to_spawn: int = randi_range(min_spawn, max_spawn)
	print("spawned %d enemies" % amount_to_spawn)
	var spawn_position_nodes: Array[Node] = $EnemiesSpawn.get_children()
	for i in range(amount_to_spawn):
		var n: Node2D = spawn_position_nodes.pick_random()
		spawn_position_nodes.erase(n)
		var s = selection.pick_random()
		var enemy = s.instantiate()
		enemy.position = n.position
		add_child(enemy)
	connect_enemies()


func on_player_died():
	player_died = true
	player_inst = get_player()
	remove_child(player_inst)
	show_arena_end()


func on_player_damaged(damage: float) -> void:
	player_damage_taken += damage


func on_enemy_damaged(damage: float) -> void:
	enemies_damage_taken += damage


func on_enemies_died(param: Dictionary):
	if param != null:
		if param.has("experience"):
			var drop_exp: int = param["experience"]
			player_experience_gained += drop_exp
			get_player().gain_experience(drop_exp)
		if param.has("gold"):
			var drop_gold: int = param["gold"]
			gold_to_gain += drop_gold
	current_enemies_count -= 1
	print("current enemies count %d" % current_enemies_count)
	kills += 1
	if current_enemies_count == 0:
		show_arena_end()


func _on_combat_timer_timeout() -> void:
	current_arena_time += 1
	set_combat_time(current_arena_time)


func completion_grade() -> String:
	if player_died:
		return "F"
	var time: int = current_arena_time
	if time < 15:
		return "A"
	if time < 30:
		return "B"
	if time < 40:
		return "C"
	if time < 50:
		return "D"
	if time < 60:
		return "E"
	return "F"

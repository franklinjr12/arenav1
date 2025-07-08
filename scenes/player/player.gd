extends CharacterBody2D
class_name Player

signal died
signal damaged
signal levelled_up
signal gold_changed
signal health_changed

@export var SPEED = 4000.0
@export var player_distance = 20
@export var stats: PlayerStats

# initial spells
@onready var basic_spell = preload("res://scenes/spells/basic_spell.tscn")
# @onready var basic_spell = preload("res://scenes/spells/fireball/fireball.tscn")
# @onready var basic_spell = preload("res://scenes/spells/ice_cone/ice_cone.tscn")
# @onready var basic_spell = preload("res://scenes/spells/bolt/bolt.tscn")
@onready var three_shot_spell = preload("res://scenes/spells/three_shot/three_shot.tscn")
@onready var area_spell = preload("res://scenes/spells/area_spell.tscn")
@onready var shield_spell = preload("res://scenes/spells/shield_spell/shield_spell.tscn")

# equipped spells
var q_action: PackedScene = null
var w_action: PackedScene = null
var e_action: PackedScene = null
var r_action: PackedScene = null

# add initial spells to acquired
var acquired_spells: Array[PackedScene] = []

#effects
@onready var blink_particles = preload("res://effects/blink_particles/blink_particles.tscn")
@onready var yellow_glow_shader = preload("res://scenes/player/yellow_glow.gdshader")

var target_position: Vector2 = Vector2.ZERO
var position_threshold: int = 20
var should_blink = false
var blink_distance = 100
var shield_on = false
var is_invulnerable: bool = false

const base_blink_cooldown = 2.0

func _init() -> void:
	# initial spells
	basic_spell = load("res://scenes/spells/basic_spell.tscn")
	three_shot_spell = load("res://scenes/spells/three_shot/three_shot.tscn")
	area_spell = load("res://scenes/spells/area_spell.tscn")
	shield_spell = load("res://scenes/spells/shield_spell/shield_spell.tscn")
	# equipped spells
	q_action = basic_spell
	w_action = three_shot_spell
	e_action = shield_spell
	r_action = area_spell
	# add initial spells to acquired
	acquired_spells = [basic_spell, three_shot_spell, shield_spell, area_spell]


func _ready() -> void:
	var health_bar = get_tree().get_first_node_in_group("PlayerHealthBar")
	if health_bar != null:
		health_bar.set_max($PlayerStats.max_health_points)
		health_bar.set_current($PlayerStats.health_points)
	apply_dexterity_to_cooldowns()
	# to make sure player does not start a scene moving
	target_position = position
	$AnimationPlayer.stop()
	stats = $PlayerStats
	set_action_timers()


func _process(_delta: float) -> void:
	var dir = (get_global_mouse_position() - position).normalized()
	if Input.is_action_pressed("q_action"):
		trigger_action_q(dir)
	if Input.is_action_pressed("w_action"):
		trigger_action_w(dir)
	if Input.is_action_pressed("e_action"):
		trigger_action_e(dir)
	if Input.is_action_pressed("r_action"):
		trigger_action_r(dir)
	if Input.is_action_pressed("dodge") && $BlinkTimer.is_stopped():
		should_blink = true
		$BlinkTimer.start()



func _physics_process(delta: float) -> void:
	if should_blink:
		should_blink = false
		trigger_blink()
		var mouse_pos = get_global_mouse_position()
		# var mouse_pos = get_local_mouse_position()
		position += (mouse_pos - position).normalized() * blink_distance
		# zeroing the speed after blink to avoid movement issues
		velocity = Vector2.ZERO
	if Input.is_action_pressed("move"):
		var mouse_pos = get_global_mouse_position()
		target_position = mouse_pos
		var final_speed = SPEED * $PlayerStats.get_speed_increase() * delta
		velocity = (mouse_pos - position).normalized() * final_speed
		$AnimationPlayer.play("player_move_animation")
	if (position - target_position).length_squared() < position_threshold:
		velocity = Vector2.ZERO
		$AnimationPlayer.stop()
	move_and_slide()


func activate_shield() -> void:
	shield_on = true
	# $Sprite2D.modulate = Color.YELLOW
	$Sprite2D.material.shader = yellow_glow_shader


func add_spell(spell: PackedScene) -> void:
	acquired_spells.append(spell)
	print(acquired_spells)


func apply_dexterity_to_cooldowns() -> void:
	if $PlayerStats.get_cooldown_reduction() > 0:
		$BlinkTimer.wait_time = base_blink_cooldown * $PlayerStats.get_cooldown_reduction()


func deactivate_shield() -> void:
	shield_on = false
	# $Sprite2D.modulate = Color.WHITE
	$Sprite2D.material.shader = null


func gain_experience(points: int) -> void:
	$PlayerStats.gain_experience_points(points)


func get_current_health() -> int:
	return $PlayerStats.health_points


func get_experience() -> int:
	return $PlayerStats.experience_points


func get_gold() -> int:
	return $PlayerStats.gold


func heal(amount: int) -> void:
	if $PlayerStats.health_points + amount > $PlayerStats.max_health_points:
		$PlayerStats.health_points = $PlayerStats.max_health_points
	else:
		$PlayerStats.health_points += amount
	health_changed.emit($PlayerStats.health_points)


func get_level() -> int:
	return $PlayerStats.level


func get_max_health() -> int:
	return $PlayerStats.max_health_points


func gain_gold(amount: int) -> void:
	$PlayerStats.gold += amount
	gold_changed.emit($PlayerStats.gold)


func loose_gold(amount: int) -> void:
	$PlayerStats.gold -= amount
	gold_changed.emit($PlayerStats.gold)


func set_action(key: String, new_action: PackedScene) -> void:
	match(key.to_upper()):
		"Q":
			q_action = new_action
		"W":
			w_action = new_action
		"E":
			e_action = new_action
		"R":
			r_action = new_action
	set_action_timers()


func set_action_timers() -> void:
	var cdr: float = $PlayerStats.get_cooldown_reduction()
	if cdr == 0:
		cdr = 1
	$QActionTimer.wait_time = q_action.instantiate().base_cooldown * cdr
	$WActionTimer.wait_time = w_action.instantiate().base_cooldown * cdr
	$EActionTimer.wait_time = e_action.instantiate().base_cooldown * cdr
	$RActionTimer.wait_time = r_action.instantiate().base_cooldown * cdr


func set_initial_values() -> void:
	$PlayerStats.health_points = $PlayerStats.max_health_points
	health_changed.emit($PlayerStats.health_points)


func suffer_damage(number: int):
	if shield_on || is_invulnerable:
		return
	$SpriteFlasher.flash()
	$PlayerStats.health_points -= number
	damaged.emit(number)
	health_changed.emit($PlayerStats.health_points)
	var health_bar = get_tree().get_first_node_in_group("PlayerHealthBar")
	if health_bar != null:
		health_bar.set_current($PlayerStats.health_points)
	if $PlayerStats.health_points <= 0:
		died.emit()


func trigger_blink() -> void:
	var blink_particles_inst = blink_particles.instantiate()
	blink_particles_inst.position = position
	get_tree().get_first_node_in_group("Arena").add_child(blink_particles_inst)
	var blink_ui: PlayerSpellButton = get_tree().get_first_node_in_group("PlayerBlink")
	if blink_ui != null:
		blink_ui.set_wait_time($BlinkTimer.wait_time)
		blink_ui.start_cooldown()


func trigger_spell_cooldown(spell: String):
	var spell_ui: PlayerSpellButton = get_tree().get_first_node_in_group("PlayerSpellButton" + spell)
	if spell_ui != null:
		spell_ui.set_wait_time(get_node(spell + "ActionTimer").wait_time)
		spell_ui.start_cooldown()


func trigger_action_q(direction: Vector2):
	if $QActionTimer.is_stopped():
		var action = q_action.instantiate()
		action.position = position + direction * player_distance
		action.set_direction(direction)
		action.set_caster(self)
		action.base_damage = action.base_damage * $PlayerStats.get_damage_multiplier()
		get_tree().get_first_node_in_group("Arena").add_child(action)
		trigger_spell_cooldown("Q")
		$QActionTimer.start()


func trigger_action_w(direction: Vector2):
	if $WActionTimer.is_stopped():
		var action = w_action.instantiate()
		action.position = position + direction * player_distance
		action.base_damage = action.base_damage * $PlayerStats.get_damage_multiplier()
		action.set_direction(direction)
		action.set_caster(self)
		get_tree().get_first_node_in_group("Arena").add_child(action)
		trigger_spell_cooldown("W")
		$WActionTimer.start()


func trigger_action_e(direction: Vector2):
	if $EActionTimer.is_stopped():
		var action = e_action.instantiate()
		action.position = position + direction * player_distance
		action.set_direction(direction)
		action.set_caster(self)
		get_tree().get_first_node_in_group("Arena").add_child(action)
		trigger_spell_cooldown("E")
		$EActionTimer.start()


func trigger_action_r(direction: Vector2):
	if $RActionTimer.is_stopped():
		var action: ProjectileSpell = r_action.instantiate()
		action.position = position + direction * player_distance
		action.set_direction(direction)
		action.set_caster(self)
		get_tree().get_first_node_in_group("Arena").add_child(action)
		trigger_spell_cooldown("R")
		$RActionTimer.start()


func on_level_up():
	$PlayerStats.health_points = $PlayerStats.max_health_points
	var health_bar = get_tree().get_first_node_in_group("PlayerHealthBar")
	if health_bar != null:
		health_bar.set_max($PlayerStats.health_points)
		health_bar.set_current($PlayerStats.health_points)
	levelled_up.emit()

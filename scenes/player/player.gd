extends CharacterBody2D
class_name Player

signal died
signal damaged

@export var SPEED = 4000.0
@export var player_distance = 20

@onready var basic_spell = preload("res://scenes/spells/basic_spell.tscn")
@onready var area_spell = preload("res://scenes/spells/area_spell.tscn")

var target_position: Vector2 = Vector2.ZERO
var position_threshold: int = 20
var should_blink = false
var blink_distance = 100
var shield_on = false
var is_invulnerable: bool = false

const base_blink_cooldown = 2.0

func _ready() -> void:
	var health_bar = get_tree().get_first_node_in_group("PlayerHealthBar")
	if health_bar != null:
		health_bar.set_max($PlayerStats.max_health_points)
		health_bar.set_current($PlayerStats.health_points)
	apply_dexterity_to_cooldowns()


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
		var mouse_pos = get_global_mouse_position()
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


func apply_dexterity_to_cooldowns() -> void:
	if $PlayerStats.get_cooldown_reduction() > 0:
		$BlinkTimer.wait_time = base_blink_cooldown * $PlayerStats.get_cooldown_reduction()


func gain_experience(points: int) -> void:
	$PlayerStats.gain_experience_points(points)


func get_current_health() -> int:
	return $PlayerStats.health_points


func get_experience() -> int:
	return $PlayerStats.experience_points


func get_level() -> int:
	return $PlayerStats.level


func get_max_health() -> int:
	return $PlayerStats.max_health_points


func set_initial_values() -> void:
	$PlayerStats.health_points = $PlayerStats.max_health_points


func suffer_damage(number: int):
	if shield_on || is_invulnerable:
		return
	$SpriteFlasher.flash()
	$PlayerStats.health_points -= number
	damaged.emit(number)
	var health_bar = get_tree().get_first_node_in_group("PlayerHealthBar")
	if health_bar != null:
		health_bar.set_current($PlayerStats.health_points)
	if $PlayerStats.health_points <= 0:
		died.emit()


func trigger_spell_cooldown(spell: String):
	var spell_ui: PlayerSpellButton = get_tree().get_first_node_in_group("PlayerSpellButton" + spell)
	if spell_ui != null:
		spell_ui.set_wait_time(get_node(spell + "ActionTimer").wait_time)
		spell_ui.start_cooldown()


func trigger_action_q(direction: Vector2):
	if $QActionTimer.is_stopped():
		var action = basic_spell.instantiate()
		action.position = position + direction * player_distance
		action.set_direction(direction)
		action.set_caster(self)
		action.base_damage = action.base_damage * $PlayerStats.get_damage_multiplier()
		get_tree().get_first_node_in_group("Arena").add_child(action)
		trigger_spell_cooldown("Q")
		$QActionTimer.start()


func trigger_action_w(direction: Vector2):
	if $WActionTimer.is_stopped():
		var angle: float = deg_to_rad(30)
		var lifetime = 0.5
		for i in [-1,0,1]:
			var direction_rotation = Vector2(direction.x*cos(angle*i) - direction.y*sin(angle*i),
											direction.x*sin(angle*i) + direction.y*cos(angle*i))
			var action = basic_spell.instantiate()
			action.position = position + direction_rotation * player_distance
			action.set_direction(direction_rotation)
			action.set_caster(self)
			action.set_lifetime(lifetime)
			get_tree().get_first_node_in_group("Arena").add_child(action)
		trigger_spell_cooldown("W")
		$WActionTimer.start()


func trigger_action_e(_direction: Vector2):
	if $EActionTimer.is_stopped():
		shield_on = true
		trigger_spell_cooldown("E")
		$EActionTimer.start()

func trigger_action_r(_direction: Vector2):
	if $RActionTimer.is_stopped():
		var action: ProjectileSpell = area_spell.instantiate()
		action.position = position
		action.set_caster(self)
		get_tree().get_first_node_in_group("Arena").add_child(action)
		trigger_spell_cooldown("R")
		$RActionTimer.start()


func _on_e_action_timer_timeout():
	shield_on = false


func on_level_up():
	$PlayerStats.health_points = $PlayerStats.max_health_points
	var health_bar = get_tree().get_first_node_in_group("PlayerHealthBar")
	if health_bar != null:
		health_bar.set_max($PlayerStats.health_points)
		health_bar.set_current($PlayerStats.health_points)

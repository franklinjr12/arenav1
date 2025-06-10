extends CharacterBody2D
class_name Player

signal died

@export var SPEED = 4000.0
@export var player_distance = 20

@onready var basic_spell = preload("res://scenes/basic_spell.tscn")
@onready var area_spell = preload("res://scenes/area_spell.tscn")

var target_position: Vector2 = Vector2.ZERO
var position_threshold: int = 20
var should_blink = false
var blink_distance = 100
var shield_on = false

func _ready() -> void:
	# not sure why signal is not triggering
	# $PlayerStats.levelled_up.connect(on_level_up)
	pass


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
		velocity = (mouse_pos - position).normalized() * SPEED * delta
		$AnimationPlayer.play("player_move_animation")
	if (position - target_position).length_squared() < position_threshold:
		velocity = Vector2.ZERO
		$AnimationPlayer.stop()
	move_and_slide()


func gain_experience(points: int) -> void:
	$PlayerStats.gain_experience_points(points)


func get_experience() -> int:
	return $PlayerStats.experience_points


func get_level() -> int:
	return $PlayerStats.level


func set_initial_values() -> void:
	$PlayerStats.health_points = $PlayerStats.max_health_points
	var health_bar = get_tree().get_first_node_in_group("PlayerHealthBar")
	if health_bar != null:
		health_bar.set_max($PlayerStats.health_points)
		health_bar.set_current($PlayerStats.health_points)


func suffer_damage(number: int):
	if shield_on:
		return
	$SpriteFlasher.flash()
	$PlayerStats.health_points -= number
	var health_bar = get_tree().get_first_node_in_group("PlayerHealthBar")
	if health_bar != null:
		health_bar.set_current($PlayerStats.health_points)
	if $PlayerStats.health_points <= 0:
		died.emit()


func trigger_spell_cooldown(spell: String):
	var q_ui = get_tree().get_first_node_in_group("PlayerSpellsUi").get_node("HBoxContainer/Spell" + spell)
	if q_ui != null:
		q_ui.get_node("Timer").wait_time = get_node(spell + "ActionTimer").wait_time
		q_ui.start_cooldown()


func trigger_action_q(direction: Vector2):
	if $QActionTimer.is_stopped():
		var action = basic_spell.instantiate()
		action.position = position + direction * player_distance
		action.set_direction(direction)
		action.set_caster(self)
		action.base_damage = action.base_damage * $PlayerStats.damage_multiplier
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
		var action = area_spell.instantiate()
		action.position = position
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

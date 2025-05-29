extends CharacterBody2D
class_name Player

@export var SPEED = 300.0
@export var player_distance = 20

@onready var basic_spell = preload("res://scenes/basic_spell.tscn")

var health_points: int = 10
var target_position: Vector2 = Vector2.ZERO
var position_threshold: int = 20
var should_blink = false
var blink_distance = 100

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



func _physics_process(delta: float) -> void:
	if should_blink:
		should_blink = false
		var mouse_pos = get_global_mouse_position()
		position += (mouse_pos - position).normalized() * blink_distance
		# position = mouse_pos
		velocity = Vector2.ZERO
	if Input.is_action_pressed("move"):
		var mouse_pos = get_global_mouse_position()
		target_position = mouse_pos
		velocity = (mouse_pos - position).normalized() * SPEED
	if (position - target_position).length_squared() < position_threshold:
		velocity = Vector2.ZERO
	move_and_slide()


func suffer_damage(number: int):
	health_points -= number
	if health_points <= 0:
		queue_free()

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
		# TODO should check if is in arena
		get_tree().get_first_node_in_group("Game").add_child(action)
		trigger_spell_cooldown("Q")
		$QActionTimer.start()


func trigger_action_w(direction: Vector2):
	if $WActionTimer.is_stopped():
		should_blink = true
		trigger_spell_cooldown("W")
		$WActionTimer.start()


func trigger_action_e(direction: Vector2):
	pass


func trigger_action_r(direction: Vector2):
	pass

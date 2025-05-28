extends CharacterBody2D
class_name Player

@export var SPEED = 300.0
@export var player_distance = 20

@onready var basic_spell = preload("res://scenes/basic_spell.tscn")

var health_points: int = 10
var target_position: Vector2 = Vector2.ZERO
var position_threshold: int = 20

func _process(delta: float) -> void:
	if Input.is_action_pressed("q_action"):
		trigger_action_q((get_global_mouse_position() - position).normalized())


func _physics_process(delta: float) -> void:
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


func trigger_action_q(direction: Vector2):
	if $QActionTimer.is_stopped():
		var action = basic_spell.instantiate()
		action.position = position + direction * player_distance
		action.set_direction(direction)
		# TODO should check if is in arena
		get_tree().get_first_node_in_group("Game").add_child(action)
		$QActionTimer.start()

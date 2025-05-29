extends CharacterBody2D
class_name Enemy

@onready var melee_spell = preload("res://scenes/melee_spell.tscn")

var health_points = 5
var attack_range = 30
var should_chase = false
@export var chase_range = 300
@export var speed_multiplier = 2500

func _process(_delta: float):
	var player: Player = get_player()
	if player != null:
		var distance = player.position - position
		var distance_length = distance.length()
		if distance_length < attack_range && can_attack():
			var attack = melee_spell.instantiate()
			attack.position = position + distance
			# TODO should check if is in arena
			get_tree().get_first_node_in_group("Game").add_child(attack)
			$AttackTimer.start()
		if distance_length < chase_range:
			should_chase = true
		else:
			should_chase = false


func _physics_process(delta: float) -> void:
	if should_chase:
		var player: Player = get_player()
		if player != null:
			var distance = player.position - position
			velocity = distance.normalized() * speed_multiplier * delta
	else:
		velocity = Vector2.ZERO
	move_and_slide()


func suffer_damage(number: int):
	health_points -= number
	if health_points <= 0:
		queue_free()


func get_player():
	return get_tree().get_first_node_in_group("player")


func can_attack():
	if $AttackTimer.is_stopped():
		return true
	return false

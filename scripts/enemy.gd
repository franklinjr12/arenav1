extends CharacterBody2D
class_name Enemy

signal died

@onready var melee_spell = preload("res://scenes/melee_spell.tscn")
@export var chase_range: int = 300
@export var speed_multiplier: int = 2500

var health_points: float = 5
var attack_range: int = 30
var should_chase: bool = false
var last_player_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	$HealthBar.set_current(health_points)
	$HealthBar.set_max(health_points)


func _process(_delta: float):
	var player: Player = get_player()
	if player != null:
		var distance = player.position - position
		var distance_length = distance.length()
		if distance_length <= attack_range && can_attack():
			last_player_position = position + distance
			$AnimationPlayer.play("attack")
		if distance_length < chase_range && distance_length > attack_range:
			should_chase = true
		else:
			should_chase = false


func _physics_process(delta: float) -> void:
	if should_chase:
		var player: Player = get_player()
		if player != null:
			var distance = player.position - position
			velocity = distance.normalized() * speed_multiplier * delta
			$AnimationPlayer.play("enemy_move_animation")
	else:
		velocity = Vector2.ZERO
		if $AnimationPlayer.current_animation == "enemy_move_animation":
			$AnimationPlayer.stop()
	move_and_slide()


func instantiate_attack():
	var attack = melee_spell.instantiate()
	attack.position = last_player_position
	get_tree().get_first_node_in_group("Arena").add_child(attack)
	$AttackTimer.start()


func suffer_damage(number: int):
	$SpriteFlasher.flash()
	health_points -= number
	if health_points <= 0:
		died.emit()
		queue_free()
	$HealthBar.set_current(health_points)


func get_player():
	return get_tree().get_first_node_in_group("player")


func can_attack():
	if $AttackTimer.is_stopped():
		return true
	return false

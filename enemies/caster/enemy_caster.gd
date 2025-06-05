extends CharacterBody2D
class_name EnemyCharacter

signal died

@export var chase_range: int = 300
@export var speed_multiplier: int = 2500

@onready var basic_spell = preload("res://scenes/basic_spell.tscn")

const cast_distance = 20

var health_points: float = 5
var attack_range: int = 200
var should_chase: bool = false
var last_player_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	$HealthBar.set_current(health_points)
	$HealthBar.set_max(health_points)
	$AttackTimer.one_shot = true


func _process(_delta: float):
	var player: Player = get_player()
	if player != null:
		var distance = player.position - position
		var distance_length = distance.length()
		if distance_length <= attack_range && can_attack():
			last_player_position = position + distance
			# $AnimationPlayer.play("attack")
			instantiate_attack()
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
			# $AnimationPlayer.play("enemy_move_animation")
	else:
		velocity = Vector2.ZERO
		#if $AnimationPlayer.current_animation == "enemy_move_animation":
			#$AnimationPlayer.stop()
	move_and_slide()


func instantiate_attack():
	var attack = basic_spell.instantiate()
	var direction = (last_player_position - position).normalized()
	attack.position = position + direction * cast_distance
	attack.set_direction(direction)
	attack.set_caster(self)
	# TODO should check if is in arena
	get_tree().get_first_node_in_group("Game").add_child(attack)
	$AttackTimer.start()


func get_player() -> Player:
	return get_tree().get_first_node_in_group("player")


func can_attack() -> bool:
	return $AttackTimer.is_stopped()


func suffer_damage(number: int):
	$SpriteFlasher.flash()
	health_points -= number
	if health_points <= 0:
		died.emit()
		queue_free()
	$HealthBar.set_current(health_points)

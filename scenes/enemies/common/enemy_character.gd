extends CharacterBody2D
class_name EnemyCharacter

signal died

enum State {IDLE, CHASING, ATTACKING}

@export var spell: PackedScene

var last_player_position: Vector2 = Vector2.ZERO
var current_state: State
var should_chase: bool = false
var should_attack: bool = false

func _ready() -> void:
	current_state = State.IDLE
	$AttackTimer.one_shot = true
	$AttackTimer.wait_time = $EnemyStats.attack_wait_time
	$HealthBar.set_max($EnemyStats.health_points)
	$HealthBar.set_current($EnemyStats.health_points)


func _process(_delta: float) -> void:
	var player: Player = get_player()
	if player != null:
		var distance = player.position - position
		var distance_length = distance.length()
		last_player_position = position + distance
		match current_state:
			State.IDLE:
				if distance_length < $EnemyStats.chase_range:
					current_state = State.CHASING
					should_chase = true
			State.CHASING:
				if distance_length <= $EnemyStats.attack_range && can_attack():
					current_state = State.ATTACKING
					should_chase = false
				elif distance_length > $EnemyStats.chase_range:
					current_state = State.IDLE
					should_chase = false
			State.ATTACKING:
				if can_attack():
					should_attack = true
				if distance_length > $EnemyStats.attack_range:
					current_state = State.CHASING
					should_chase = true


func _physics_process(delta: float) -> void:
	if should_attack:
		should_attack = false
		$AnimationPlayer.play("attack")
	if should_chase:
		var player: Player = get_player()
		if player != null:
			var distance = player.position - position
			velocity = distance.normalized() * $EnemyStats.speed_multiplier * delta
			$AnimationPlayer.play("enemy_move_animation")
	else:
		velocity = Vector2.ZERO
		if $AnimationPlayer.current_animation == "enemy_move_animation":
			$AnimationPlayer.stop()
	move_and_slide()


func can_attack() -> bool:
	return $AttackTimer.is_stopped() && !should_attack


func instantiate_attack():
	var attack = spell.instantiate()
	var direction = (last_player_position - position).normalized()
	attack.position = position + direction * $EnemyStats.cast_distance
	attack.set_direction(direction)
	attack.set_caster(self)
	get_tree().get_first_node_in_group("Arena").add_child(attack)
	$AttackTimer.start()
	should_attack = false


func get_player() -> Player:
	return get_tree().get_first_node_in_group("Player")


func suffer_damage(number: int):
	$SpriteFlasher.flash()
	$EnemyStats.health_points -= number
	if $EnemyStats.health_points <= 0:
		var signal_param = {"experience": $EnemyStats.experience_drop}
		died.emit(signal_param)
		queue_free()
	$HealthBar.set_current($EnemyStats.health_points)

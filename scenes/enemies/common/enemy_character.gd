extends CharacterBody2D
class_name EnemyCharacter

signal died
signal damaged

enum State {IDLE, CHASING, ATTACKING}

@export var spell: PackedScene
@export var stats: EnemyStats

@onready var experience_orb_scene: PackedScene = preload("res://scenes/experience_orb/experience_orb.tscn")
@onready var die_particle_scene: PackedScene = preload("res://effects/die_particles/die_particle.tscn")

var last_player_position: Vector2 = Vector2.ZERO
var current_state: State
var should_chase: bool = false
var should_attack: bool = false
var knockback: Vector2 = Vector2.ZERO
var slow_percentage: int = 0

func _ready() -> void:
	current_state = State.IDLE
	$AttackTimer.one_shot = true
	stats = $EnemyStats
	$AttackTimer.wait_time = $EnemyStats.attack_wait_time
	$HealthBar.set_max($EnemyStats.health_points)
	$HealthBar.set_current($EnemyStats.health_points)


func _process(_delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	run_state_machine()
	if should_attack:
		should_attack = false
		$AnimationPlayer.play("attack")
	if should_chase:
		var player: Player = get_player()
		if player != null:
			var distance: Vector2 = player.position - position
			velocity = distance.normalized() * $EnemyStats.speed_multiplier * delta
			$AnimationPlayer.play("enemy_move_animation")
	else:
		velocity = Vector2.ZERO
		if $AnimationPlayer.current_animation == "enemy_move_animation":
			$AnimationPlayer.stop()
	if slow_percentage != 0 && velocity != Vector2.ZERO:
		if slow_percentage > 100:
			slow_percentage = 100
		velocity = velocity * (100.0 - slow_percentage) / 100.0
		slow_percentage = 0
	if knockback.x != 0 || knockback.y != 0:
		velocity += knockback
		knockback = Vector2.ZERO
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


func run_state_machine() -> void:
	var player: Player = get_player()
	if player == null:
		return
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
			elif distance_length > $EnemyStats.attack_range:
				current_state = State.CHASING
				should_chase = true


func suffer_damage(number: int):
	$SpriteFlasher.flash()
	$EnemyStats.health_points -= number
	damaged.emit(number)
	if $EnemyStats.health_points <= 0:
		die()
	$HealthBar.set_current($EnemyStats.health_points)


func suffer_knockback(direction, strength) -> void:
	knockback += direction * strength


func suffer_slow(percentage: int) -> void:
	slow_percentage += percentage


func die() -> void:
	var signal_param = {
		"experience": $EnemyStats.experience_drop,
		"gold": $EnemyStats.gold_drop
	}
	died.emit(signal_param)
	var experience_orb = experience_orb_scene.instantiate()
	experience_orb.position = position
	experience_orb.set_dropped_experience($EnemyStats.experience_drop)
	var die_particle: DieParticle = die_particle_scene.instantiate()
	die_particle.position = position
	die_particle.sprite_size = $Sprite2D.get_rect().size
	get_tree().get_first_node_in_group("Arena").add_child(experience_orb)
	get_tree().get_first_node_in_group("Arena").add_child(die_particle)
	queue_free()

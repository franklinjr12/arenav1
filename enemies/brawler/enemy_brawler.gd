extends CharacterBody2D

var should_chase: bool = false
var last_player_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	$AttackTimer.one_shot = true
	$AttackTimer.wait_time = $EnemyResource.attack_wait_time
	$HealthBar.set_max($EnemyResource.health_points)
	$HealthBar.set_current($EnemyResource.health_points)


func _process(_delta: float) -> void:
	var player: Player = get_player()
	if player != null:
		var distance = player.position - position
		var distance_length = distance.length()
		if distance_length <= $EnemyResource.attack_range && can_attack():
			last_player_position = position + distance
			# $AnimationPlayer.play("attack")
			# instantiate_attack()
			print("attacking")
		if distance_length < $EnemyResource.chase_range && distance_length > $EnemyResource.attack_range:
			should_chase = true
		else:
			should_chase = false


func get_player() -> Player:
	return get_tree().get_first_node_in_group("player")


func can_attack() -> bool:
	return $AttackTimer.is_stopped()

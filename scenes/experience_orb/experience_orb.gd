extends Node2D

@export var dropped_experience : int = 1

const VELOCITY_MAG = 300
var velocity : Vector2 = Vector2.ONE
var direction : Vector2 = Vector2.ONE
var player : Player = null

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	if player != null:
		direction = (player.position - position).normalized()

func _process(delta):
	if player != null:
		direction = (player.position - position).normalized()
		position +=  direction * velocity * delta * VELOCITY_MAG


func _on_player_entered(body):
	if body is Player:
		# had some issues with player dying and then receiving exp
		if body != null:
			body.gain_experience(dropped_experience)
		queue_free()

func set_dropped_experience(value : int):
	dropped_experience = value

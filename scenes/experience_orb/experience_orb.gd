extends Node2D

@export var dropped_experience : int = 1

const VELOCITY_MAG = 300
const DISSAPEAR_DIST: int = 10
var velocity : Vector2 = Vector2.ONE
var direction : Vector2 = Vector2.ONE
var player : Player = null

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	if player != null:
		direction = (player.position - position).normalized()


func _process(delta):
	if player != null:
		if (player.position - position).length() <= DISSAPEAR_DIST:
			# not needed for now since we give player exp through signal
			# player.gain_experience(dropped_experience)
			queue_free()
		direction = (player.position - position).normalized()
		position +=  direction * velocity * delta * VELOCITY_MAG


func set_dropped_experience(value : int):
	dropped_experience = value

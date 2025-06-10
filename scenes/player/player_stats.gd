extends Node

signal levelled_up

@export var health_points: int = 100
@export var max_health_points: int = 100
@export var experience_points: int = 0
@export var level: int = 0
@export var damage_multiplier: float = 10

const base_level_up: int = 10

var last_experience_points: int = 0

func gain_experience_points(value: int) -> void:
	experience_points += value
	var needed_points = last_experience_points + base_level_up * (level + 1)
	if experience_points > needed_points:
		print("player levelled up")
		last_experience_points = experience_points
		level += 1
		var param: Dictionary = {"level": level}
		levelled_up.emit(param)
		# not sure why signal is not triggering
		get_parent().on_level_up()

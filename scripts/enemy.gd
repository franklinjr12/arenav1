extends CharacterBody2D
class_name Enemy

var health_points = 5

func suffer_damage(number: int):
	health_points -= number
	if health_points <= 0:
		queue_free()

class_name PlayerStats
extends Node

signal levelled_up

@export var health_points: int = 100
@export var max_health_points: int = 100
@export var experience_points: int = 0
@export var level: int = 0
@export var damage_multiplier: float = 10

@export var intelligence: int = 1 # affects damage_multiplier
@export var dexterity: int = 1 # affects cooldowns
@export var swiftness: int = 1 # affects move speed
@export var vitality: int = 1 # affects health
@export var luck: int = 1 # affects exp gain

const base_level_up: int = 10
const max_attribute_value: int = 10

var last_experience_points: int = 0
var available_attribute_points: int = 0

func gain_experience_points(value: int) -> void:
	experience_points += value *  (1 + (float(luck - 1) / max_attribute_value))
	var needed_points = last_experience_points + base_level_up * (level + 1)
	if experience_points > needed_points:
		last_experience_points = experience_points
		level += 1
		available_attribute_points += 1
		var param: Dictionary = {"level": level}
		levelled_up.emit(param)
		# not sure why signal is not triggering
		get_parent().on_level_up()


func get_cooldown_reduction() -> float:
	return  1 - float(dexterity - 1) / max_attribute_value


func get_damage_multiplier() -> float:
	return intelligence * damage_multiplier


func get_speed_increase() -> float:
	return 1 + (float(swiftness - 1) / max_attribute_value)

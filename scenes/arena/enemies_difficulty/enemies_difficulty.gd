extends Resource
class_name EnemiesDifficultyResource

#var enemy_rat = preload("res://scenes/enemies/rat/enemy_rat.tscn")
#var enemy_caster = preload("res://scenes/enemies/caster/enemy_caster.tscn")
#var enemy_brawler = preload("res://scenes/enemies/brawler/enemy_brawler.tscn")
#
#var enemies_spawn: Dictionary = {
	#"easy": [enemy_rat, enemy_rat, enemy_rat],
	#"medium": [enemy_rat, enemy_rat, enemy_caster],
	#"hard": [enemy_rat, enemy_caster, enemy_brawler]
#}

func get_enemies_spawn_setup() -> Dictionary:
	var enemy_rat = load("res://scenes/enemies/rat/enemy_rat.tscn")
	var enemy_caster = load("res://scenes/enemies/caster/enemy_caster.tscn")
	var enemy_brawler = load("res://scenes/enemies/brawler/enemy_brawler.tscn")
	return {
		"easy": {
			"enemy_pool": [enemy_rat, enemy_rat, enemy_caster],
			"min_spawn": 3,
			"max_spawn": 5
		},
		"medium": {
			"enemy_pool": [enemy_rat, enemy_caster, enemy_brawler],
			"min_spawn": 3,
			"max_spawn": 5
		},
		"hard": {
			"enemy_pool": [enemy_rat, enemy_caster, enemy_brawler],
			"min_spawn": 5,
			"max_spawn": 8
		},
	}

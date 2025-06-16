extends Resource
class_name EnemiesDifficultyResource

var enemy_rat = preload("res://scenes/enemies/rat/enemy_rat.tscn")
var enemy_caster = preload("res://scenes/enemies/caster/enemy_caster.tscn")
var enemy_brawler = preload("res://scenes/enemies/brawler/enemy_brawler.tscn")

var enemies_spawn: Dictionary = {
	"easy": [enemy_rat, enemy_rat, enemy_rat],
	"medium": [enemy_rat, enemy_rat, enemy_caster],
	"hard": [enemy_rat, enemy_caster, enemy_brawler]
}

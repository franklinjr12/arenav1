extends Node

@onready var shield_effect_scene: PackedScene = preload("res://effects/shield/shield.tscn")

func _ready() -> void:
	var who_casted = get_parent().who_casted
	if who_casted != null:
		var shield_effect = shield_effect_scene.instantiate()
		who_casted.add_child(shield_effect)

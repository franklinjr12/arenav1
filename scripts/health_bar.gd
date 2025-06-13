extends Control

func _ready() -> void:
	var p: Player = get_tree().get_first_node_in_group("Player")
	if p != null:
		set_current(p.get_current_health())
		set_max(p.get_max_health())


func set_current(value: float):
	$TextureProgressBar.value = value


func set_max(value: float):
	$TextureProgressBar.max_value = value

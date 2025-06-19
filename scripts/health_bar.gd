extends Control

var animated: bool = true
var change_rate: float = 1
var target_value: float

func _ready() -> void:
	# TODO deservers a refactor
	var parent: Node = get_parent()
	if parent is EnemyCharacter:
		return
	var p: Player = get_tree().get_first_node_in_group("Player")
	if p != null:
		set_current(p.get_current_health())
		set_max(p.get_max_health())
	target_value = $TextureProgressBar.value


func _physics_process(_delta: float) -> void:
	if animated && target_value != $TextureProgressBar.value:
		$TextureProgressBar.set_value_no_signal(sign(target_value - $TextureProgressBar.value) * change_rate + $TextureProgressBar.value)


func set_current(value: float):
	if animated:
		target_value = value
	else:
		$TextureProgressBar.value = value


func set_max(value: float):
	$TextureProgressBar.max_value = value

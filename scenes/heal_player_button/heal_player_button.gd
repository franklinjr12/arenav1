extends Control

var player: Player = null
var heal_gold_cost: int = 10

func _process(delta: float) -> void:
	if $MouseTooltipLabel.visible:
		var m_position = get_local_mouse_position()
		$MouseTooltipLabel.position = m_position


func _on_button_pressed() -> void:
	if player != null && player.get_gold() >= heal_gold_cost:
		player.loose_gold(heal_gold_cost)
		var hp_to_restore = player.get_max_health()
		player.heal(hp_to_restore)


func _on_mouse_entered() -> void:
	$MouseTooltipLabel.visible = true


func _on_mouse_exited() -> void:
	$MouseTooltipLabel.visible = false

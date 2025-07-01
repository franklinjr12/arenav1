extends Control

var player: Player = null

func _ready() -> void:
	size = get_viewport().size
	var node: Node = get_tree().get_first_node_in_group("Game")
	if node != null:
		player = node.player


func handle_scroll_clicked(scroll) -> void:
	if player == null:
		return
	if player.get_gold() >= scroll.gold_cost:
		player.loose_gold(scroll.gold_cost)
		player.add_spell(scroll.spell)
		scroll.queue_free()


func _on_scroll_pressed() -> void:
	handle_scroll_clicked($HBoxContainer/Scroll)


func _on_scroll_2_pressed() -> void:
	handle_scroll_clicked($HBoxContainer/Scroll2)


func _on_scroll_3_pressed() -> void:
	handle_scroll_clicked($HBoxContainer/Scroll3)

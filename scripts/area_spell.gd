extends Sprite2D

var base_damage: int = 6

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.suffer_damage(base_damage)
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()

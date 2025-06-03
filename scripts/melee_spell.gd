extends Sprite2D

var base_damage: int = 5
var damaged = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player && !damaged:
		body.suffer_damage(base_damage)
		damaged = true


func _on_deletion_timer_timeout() -> void:
	queue_free()

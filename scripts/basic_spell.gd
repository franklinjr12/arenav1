extends Sprite2D

const speed_mag = 100

var velocity : Vector2 = Vector2.ZERO
var base_damage: int = 2

func _process(delta: float):
	position.x += velocity.x * speed_mag * delta
	position.y += velocity.y * speed_mag * delta


func set_direction(direction: Vector2):
	if direction.is_normalized():
		velocity = direction
	else:
		velocity = direction.normalized()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.suffer_damage(base_damage)
	queue_free()

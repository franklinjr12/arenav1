extends Sprite2D

const speed_mag = 100

var velocity : Vector2 = Vector2.ZERO

func _process(delta: float):
	position.x += velocity.x * speed_mag * delta
	position.y += velocity.y * speed_mag * delta

func set_direction(direction: Vector2):
	if direction.is_normalized():
		velocity = direction
	else:
		velocity = direction.normalized()

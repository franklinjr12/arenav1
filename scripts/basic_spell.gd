extends Sprite2D

const speed_mag = 100

var velocity : Vector2 = Vector2.ZERO
var base_damage: int = 2
var who_casted = null

func _physics_process(delta: float) -> void:
	position.x += velocity.x * speed_mag * delta
	position.y += velocity.y * speed_mag * delta


func set_direction(direction: Vector2):
	if direction.is_normalized():
		velocity = direction
	else:
		velocity = direction.normalized()


func set_caster(caster):
	who_casted = caster


func set_lifetime(time: float):
	$LifetimeTimer.wait_time = time


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body != who_casted:
		if body.has_method("suffer_damage"):
			body.suffer_damage(base_damage)
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()

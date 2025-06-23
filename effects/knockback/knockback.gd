extends Node

@export var direction: Vector2 = Vector2.ZERO
@export var strenght: int = 0

func _physics_process(_delta: float) -> void:
	var parent = get_parent()
	if parent.has_method("suffer_knockback"):
		parent.suffer_knockback(direction, strenght)


func _on_timer_timeout() -> void:
	queue_free()

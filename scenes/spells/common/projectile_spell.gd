extends Node2D
class_name ProjectileSpell

@export var base_damage: int = 2
@export var speed_mag = 100

@onready var damage_number_scene: PackedScene = preload("res://scenes/damage_number/damage_number.tscn")

var velocity : Vector2 = Vector2.ZERO
var direction : Vector2 = Vector2.ZERO
var who_casted = null

func _ready() -> void:
	var t: Timer = get_node_or_null("LifetimeTimer")
	if t != null:
		t.timeout.connect(_on_timer_timeout)
	var area: Area2D = get_node_or_null("Area2D")
	if area != null:
		area.body_entered.connect(_on_area_2d_body_entered)


func _physics_process(delta: float) -> void:
	position.x += velocity.x * speed_mag * delta
	position.y += velocity.y * speed_mag * delta


func set_direction(_direction: Vector2):
	if _direction.is_normalized():
		direction = _direction
		velocity = _direction
	else:
		direction = _direction.normalized()
		velocity = direction


func set_caster(caster):
	who_casted = caster


func set_lifetime(time: float):
	$LifetimeTimer.wait_time = time


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body != who_casted:
		if body.has_method("suffer_damage"):
			body.suffer_damage(base_damage)
		var damage_number = damage_number_scene.instantiate()
		damage_number.position = position
		damage_number.text = str(base_damage)
		get_tree().get_first_node_in_group("Arena").add_child(damage_number)
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()

extends Node2D
class_name ProjectileSpell

@export var base_damage: int = 2
@export var speed_mag = 100
@export var knockback_strength: int = 0
@export var effects: Resource
@export var gold_cost: int = 10
@export var base_cooldown: float = 1.0
@export var spell_name: String
@export var spawn_multiple: bool = false
@export var spawn_amount: int = 0
@export var spawn_angle: float = 0

@onready var damage_number_scene: PackedScene = preload("res://scenes/damage_number/damage_number.tscn")
@onready var knockback_scene: PackedScene = preload("res://effects/knockback/knockback.tscn")

var velocity : Vector2 = Vector2.ZERO
var direction : Vector2 = Vector2.ZERO
var who_casted = null

func _ready() -> void:
	var t: Timer = get_node_or_null("LifetimeTimer")
	if t != null:
		t.timeout.connect(_on_timer_timeout)
		t.autostart = true
	var area: Area2D = get_node_or_null("Area2D")
	if area != null:
		area.body_entered.connect(_on_area_2d_body_entered)
	if spawn_multiple && spawn_amount > 1:
		spawn_multiple = false # workaround for avoiding recursion
		spawn_clones()


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
	rotation = direction.angle()


func set_caster(caster):
	who_casted = caster


func set_lifetime(time: float):
	$LifetimeTimer.wait_time = time


func spawn_clones() -> void:
	var angle: float = deg_to_rad(spawn_angle)
	for i in range(-round(spawn_amount/2),round(spawn_amount/2) + 1):
		if i == 0:
			continue # already instantiated by the player on cast
		var new_inst = self.duplicate()
		var new_direction: Vector2 = direction
		new_direction = new_direction.rotated(angle * i)
		new_inst.set_direction(new_direction)
		new_inst.set_caster(who_casted)
		new_inst.set_lifetime($LifetimeTimer.wait_time)
		new_inst.position.y += $Sprite2D.get_rect().size.y * 1.2 * i
		new_inst.base_damage = base_damage
		get_parent().add_child(new_inst)


func spawn_damage_number() -> void:
	var damage_number = damage_number_scene.instantiate()
	damage_number.position = position
	damage_number.text = str(base_damage)
	get_tree().get_first_node_in_group("Arena").add_child(damage_number)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body != who_casted:
		# apply damage
		if body.has_method("suffer_damage"):
			body.suffer_damage(base_damage)
			spawn_damage_number()
			var dot = get_node_or_null("DamageOverTime")
			if dot != null:
				body.add_child(dot.duplicate())
		# apply knockback
		if knockback_strength > 0 && body.has_method("suffer_knockback"):
			var knockback = knockback_scene.instantiate()
			knockback.direction = direction
			knockback.strength = knockback_strength
			body.add_child(knockback)
		# apply effects
		if effects != null:
			for effect in effects.data:
				var effect_inst: Node = effect["scene"].instantiate()
				for key in effect["scene_values"]:
					effect_inst.set(key, effect["scene_values"][key])
				body.add_child(effect_inst)
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()

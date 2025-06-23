extends Node

@export var tick_time: float = 1
@export var duration_time: float = 1
@export var damage: float = 1

@onready var damage_number_scene: PackedScene = preload("res://scenes/damage_number/damage_number.tscn")

func _ready() -> void:
	$TickTimer.wait_time = tick_time
	$LifetimeTimer.wait_time = duration_time


func start_timers() -> void:
	var parent = get_parent()
	if parent != null && parent.has_method("suffer_damage"):
		$TickTimer.start()
		$LifetimeTimer.start()


func _on_tick_timer_timeout() -> void:
	var parent = get_parent()
	if parent != null && parent.has_method("suffer_damage"):
		parent.suffer_damage(damage)
		var damage_number = damage_number_scene.instantiate()
		damage_number.position = parent.position
		damage_number.text = str("%d" % damage)
		get_tree().get_first_node_in_group("Arena").add_child(damage_number)


func _on_lifetime_timer_timeout() -> void:
	queue_free()


func _on_tree_entered() -> void:
	call_deferred("start_timers")

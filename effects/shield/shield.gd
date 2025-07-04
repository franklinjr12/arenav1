extends Node

@export var duration: float = 0

func _ready() -> void:
	if duration > 0:
		$Timer.wait_time = duration
	$Timer.timeout.connect(_on_timer_timeout)
	$Timer.one_shot = true
	$Timer.start()
	var parent = get_parent()
	if parent != null && parent.has_method("activate_shield"):
		parent.activate_shield()


func _physics_process(_delta: float) -> void:
	var parent = get_parent()
	if parent != null && parent.has_method("activate_shield"):
		parent.activate_shield()


func _on_timer_timeout() -> void:
	var parent = get_parent()
	if parent != null && parent.has_method("deactivate_shield"):
		parent.deactivate_shield()
	queue_free()

extends Node

@export var speed_percentage: int = 0
@export var duration: float = 0

func _ready() -> void:
	if duration > 0:
		$Timer.wait_time = duration
	$Timer.timeout.connect(_on_timer_timeout)
	$Timer.one_shot = true
	$Timer.start()


func _physics_process(_delta: float) -> void:
	var parent = get_parent()
	if parent != null && parent.has_method("suffer_slow"):
		parent.suffer_slow(speed_percentage)


func _on_timer_timeout() -> void:
	queue_free()

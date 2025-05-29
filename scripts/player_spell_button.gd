extends TextureButton

func _ready():
	$Timer.timeout.connect(_on_timer_timeout)


func start_cooldown():
	$ColorRect.visible = true
	$Timer.start()


func _on_timer_timeout():
	$ColorRect.visible = false

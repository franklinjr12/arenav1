extends TextureButton

const cooldown_color: Color = Color("ff0000ab")
const color_transparency: float = cooldown_color.a


func _ready():
	$Timer.timeout.connect(_on_timer_timeout)
	$ColorRect.size = size
	$ColorRect.color = cooldown_color
	$ColorRect.visible = false


func _process(_delta: float):
	if !$Timer.is_stopped():
		var current_time: float = $Timer.time_left
		var wait_time: float = $Timer.wait_time
		var transparency: float = color_transparency * (current_time / wait_time)
		$ColorRect.color.a = transparency


func start_cooldown():
	$ColorRect.color.a = color_transparency
	$ColorRect.visible = true
	$Timer.start()


func _on_timer_timeout():
	$ColorRect.visible = false

extends Label

const VELOCITY = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y -= VELOCITY * delta

func _on_timer_timeout():
	queue_free()

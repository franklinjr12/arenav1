extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var player = get_player()
	if player != null:
		position = player.position

func get_player():
	return get_tree().get_first_node_in_group("Player")

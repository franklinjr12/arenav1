extends Node

@export var node_name: String = ""
const default_name = "Sprite2D"

func _ready() -> void:
	var material = ShaderMaterial.new()
	var flash_shader = load("res://shaders/flash.gdshader")
	material.shader = flash_shader
	get_sprite_node().material = material

func get_sprite_node() -> Sprite2D:
	var n_name = node_name
	if n_name == "":
		n_name = default_name
	return get_parent().get_node(n_name)

func flash() -> void:
	get_sprite_node().material.set_shader_parameter("solid_color", Color.WHITE)
	$Timer.start()


func _on_timer_timeout() -> void:
	get_sprite_node().material.set_shader_parameter("solid_color", Color.TRANSPARENT)

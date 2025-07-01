extends Control

signal pressed

@export var spell: Resource
@export var gold_cost: int

func _ready() -> void:
	if spell is PackedScene:
		var spell_sprite: Sprite2D = spell.instantiate().get_node("Sprite2D").duplicate()
		var spell_texture: Texture2D = spell_sprite.texture
		$TextureRect.texture = spell_texture.duplicate()
	$Label.text = str(gold_cost)


func _on_button_pressed() -> void:
	pressed.emit()

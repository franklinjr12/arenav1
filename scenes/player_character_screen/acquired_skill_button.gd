extends Button

@export var spell_scene: PackedScene

func _ready() -> void:
	var spell = spell_scene.instantiate()
	$Label.text = spell.spell_name
	$Sprite2D.texture = spell.get_node("Sprite2D").texture

extends Button

signal spell_pressed

@export var spell_scene: PackedScene

func _ready() -> void:
	var spell = spell_scene.instantiate()
	$Label.text = spell.spell_name
	$Sprite2D.texture = spell.get_node("Sprite2D").texture


func _on_pressed() -> void:
	spell_pressed.emit({"spell" = spell_scene})

extends Button

signal spell_pressed

@export var spell_scene: PackedScene

func _ready() -> void:
	if spell_scene == null:
		return
	var spell = spell_scene.instantiate()
	$Label.text = spell.spell_name
	$Sprite2D.texture = spell.get_node("Sprite2D").texture


func set_spell_scene(new_spell: PackedScene) -> void:
	spell_scene = new_spell
	var spell = spell_scene.instantiate()
	$Label.text = spell.spell_name
	$Sprite2D.texture = spell.get_node("Sprite2D").texture


func _on_pressed() -> void:
	spell_pressed.emit({"spell" = spell_scene})

class_name PlayerSpellButton
extends Control

@export var spell_texture: Texture2D

const cooldown_color: Color = Color("ff0000ab")
const color_transparency: float = cooldown_color.a

func _ready():
	$Timer.timeout.connect(_on_timer_timeout)
	$SpellSprite.texture = spell_texture
	$ColorRect.size = size
	$ColorRect.color = cooldown_color
	$ColorRect.visible = false
	$CooldownLabel.visible = false


func _process(_delta: float):
	if !$Timer.is_stopped():
		var current_time: float = $Timer.time_left
		var wait_time: float = $Timer.wait_time
		var transparency: float = color_transparency * (current_time / wait_time)
		$ColorRect.color.a = transparency
		var label_text = "%1.1f" % current_time
		$CooldownLabel.text = label_text


func set_wait_time(t: float) -> void:
	$Timer.wait_time = t


func start_cooldown():
	$ColorRect.color.a = color_transparency
	$ColorRect.visible = true
	$CooldownLabel.visible = true
	$Timer.start()


func _on_timer_timeout():
	$ColorRect.visible = false
	$CooldownLabel.visible = false

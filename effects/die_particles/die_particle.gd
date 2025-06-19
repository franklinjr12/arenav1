class_name DieParticle
extends Node2D

@export var sprite_size: Vector2 = Vector2(5,5)

func _ready() -> void:
	$CPUParticles2D.one_shot = true
	$CPUParticles2D.emission_rect_extents = sprite_size
	$CPUParticles2D.emitting = true


func _on_cpu_particles_2d_finished() -> void:
	queue_free()

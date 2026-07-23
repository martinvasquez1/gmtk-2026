class_name SimpleProjectile
extends Area2D

@export var speed: float = 400.0

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_area_entered(area: Area2D) -> void:
	print("Negative effect")

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

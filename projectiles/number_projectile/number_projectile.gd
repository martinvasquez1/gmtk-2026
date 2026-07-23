extends Area2D

@export var label: Label
@export var speed: float = 200.0

var value: int = 0

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body is EnemyNumber:
		body.queue_free()
		
	if body is Boss:
		body.current_time_seconds -= value
		queue_free()

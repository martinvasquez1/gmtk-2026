class_name SimpleProjectile
extends Area2D

@export var speed: float = 400.0
@export var hit_time_penalty: int = 20

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Player and BossGlobals.boss_node:
		if !body.is_dashing():
			BossGlobals.boss_node.current_time_seconds -= hit_time_penalty 
			PlayerGlobals.camera_shake.emit(Vector2(1,-1),0.1)
			PlayerGlobals.hitstop.emit(0.8,0.1)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

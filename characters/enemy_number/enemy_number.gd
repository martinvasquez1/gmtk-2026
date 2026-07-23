class_name EnemyNumber
extends CharacterBody2D

@export var speed: float = 20.0
@export var label: Label

var value: int
var player_node: Player = null

func _ready() -> void:
	var random_num: int = randi_range(-9, 9)
	
	value = random_num
	label.text = str(value)

func _physics_process(delta: float) -> void:
	if not player_node:
		return
		
	var target_position: Vector2 = player_node.global_position
	var direction = self.global_position.direction_to(target_position)
	
	velocity = speed * direction
	move_and_slide()

func _on_shoot_timeout() -> void:
	print("Spawn simple projectile")

func _on_player_detection_body_entered(body: Node2D) -> void:
	if body is Player:
		player_node = body

func _on_player_detection_body_exited(body: Node2D) -> void:
	if body is Player:
		player_node = null

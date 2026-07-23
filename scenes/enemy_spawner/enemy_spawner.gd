class_name EnemySpawner
extends Node

@export_group("Experimental")
## Spawns enemies inside the inner_radius when a GenerateCollisionRing is set.
@export var generate_collision_ring: GenerateCollisionRing

@onready var GetRandomRingPos: Node = $GetRandomRingPos

var enemy_number_scene := preload("res://characters/enemy_number/enemy_number.tscn")

func _ready() -> void:
	if generate_collision_ring:
		var margin := 16
		GetRandomRingPos.circular_arena_radius = generate_collision_ring.inner_radius - margin
		GetRandomRingPos.circular_arena_position = generate_collision_ring.global_position

func get_random_pos() -> Vector2:
	if generate_collision_ring:
		return GetRandomRingPos.get_random_circle_pos(GetRandomRingPos.circular_arena_radius, GetRandomRingPos.circular_arena_position)
	else:
		return Vector2.ZERO

func handle_enemy_spawn():
	var enemy_instance := enemy_number_scene.instantiate()
	
	var random_pos := get_random_pos()
	enemy_instance.global_position = random_pos
	
	get_tree().current_scene.add_child(enemy_instance)

func _on_timer_timeout() -> void:
	handle_enemy_spawn()

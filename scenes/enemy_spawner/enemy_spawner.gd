class_name EnemySpawner
extends Node

@export var generate_collision_ring: GenerateCollisionRing

var enemy_number_scene := preload("res://characters/enemy_number/enemy_number.tscn")

var viewport_x = ProjectSettings.get_setting("display/window/size/viewport_width")
var viewport_y = ProjectSettings.get_setting("display/window/size/viewport_height")

var circular_arena_radius: float
var circular_arena_position: Vector2

func _ready() -> void:
	var margin := 16
	circular_arena_radius = generate_collision_ring.inner_radius - margin
	circular_arena_position = generate_collision_ring.global_position

func get_random_circle_pos(radius: float, center_position: Vector2) -> Vector2:
	var random_angle = randf_range(0, TAU)
	var random_radius = radius * sqrt(randf())
	
	var x = random_radius * cos(random_angle) + center_position.x
	var y = random_radius * sin(random_angle) + center_position.y

	return Vector2(x, y)
	
func handle_enemy_spawn():
	var enemy_instance := enemy_number_scene.instantiate()
	
	var random_pos := get_random_circle_pos(circular_arena_radius, circular_arena_position)
	enemy_instance.global_position = random_pos
	
	get_tree().current_scene.add_child(enemy_instance)

func _on_timer_timeout() -> void:
	handle_enemy_spawn()

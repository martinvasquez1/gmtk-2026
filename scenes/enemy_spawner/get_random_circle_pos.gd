extends Node

var circular_arena_radius: float
var circular_arena_position: Vector2

func get_random_circle_pos(radius: float, center_position: Vector2) -> Vector2:
	var random_angle = randf_range(0, TAU)
	var random_radius = radius * sqrt(randf())
	
	var x = random_radius * cos(random_angle) + center_position.x
	var y = random_radius * sin(random_angle) + center_position.y

	return Vector2(x, y)

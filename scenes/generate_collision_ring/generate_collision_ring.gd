class_name GenerateCollisionRing
extends Node2D

@export var sprite: Sprite2D

@export var total_angle: float = 360
@export var inner_radius: float = 200
@export var outer_radius: float = 220

func set_border() -> void:
	var new_scale = inner_radius * 2
	sprite.scale = Vector2(new_scale, new_scale)
	sprite.visible = true

func _ready():
	var area: StaticBody2D = StaticBody2D.new()
	add_child(area)

	var collisionObject: Node2D
	collisionObject = create_donut_shape(total_angle, inner_radius, outer_radius)

	area.add_child(collisionObject)
	
	set_border()

static func create_donut_shape(totalAngle: float, innerRadius: float, outerRadius: float) -> CollisionPolygon2D:
	var collisionShape2D: CollisionPolygon2D = CollisionPolygon2D.new()
	collisionShape2D.build_mode = CollisionPolygon2D.BUILD_SOLIDS
	
	var totalPoints: int = int(totalAngle / 1)
	var angleFrom: float = -totalAngle / 2 + 90
	var angleTo: float = totalAngle / 2 + 90
	var pointsArc: PackedVector2Array = PackedVector2Array()
	
	for i in range(totalPoints + 1):
		var anglePoint: float = deg_to_rad(angleFrom + i * \
				(angleTo - angleFrom) / totalPoints - 90)
		pointsArc.push_back(Vector2(cos(anglePoint), sin(anglePoint)) \
				* outerRadius)
	
	for i in range(totalPoints, -1, -1):
		var anglePoint: float = deg_to_rad(angleFrom + i * \
				(angleTo - angleFrom) / totalPoints - 90)
		pointsArc.push_back(Vector2(cos(anglePoint), sin(anglePoint)) \
				* innerRadius)
	
	collisionShape2D.polygon = pointsArc

	return collisionShape2D

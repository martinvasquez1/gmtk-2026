extends Node2D

@export var totalAngle: float = 360
@export var innerRadius: float = 200
@export var outerRadius: float = 220


func _ready():
	var area: StaticBody2D = StaticBody2D.new()
	add_child(area)

	var collisionObject: Node2D
	collisionObject = create_donut_shape(totalAngle, innerRadius, outerRadius)

	area.add_child(collisionObject)

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

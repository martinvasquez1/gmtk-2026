class_name EnemyNumber
extends CharacterBody2D

@export_group("Internal Nodes")
@export var projectile_scene: PackedScene
@export var death_particles: PackedScene
@export var sprite : Sprite2D
@export var ghost : Sprite2D
@export var ghost2 : Sprite2D

@export_group("Values")
@export var speed: float = 20.0
@export var label: Label

var value: int
var player_node: Player = null
var type : int

var target_position: Vector2
var direction: Vector2

func _ready() -> void:
	var random_num: int = randi_range(-9, 9)
	value = random_num
	
	type = randi_range(0,2)
	sprite.frame = type
	ghost.frame = type
	ghost2.frame = type
	
	label.text = str(value)

func _physics_process(_delta: float) -> void:
	if not player_node:
		return
		
	
	handle_ghost()
	
	velocity = speed * direction
	move_and_slide()

func handle_ghost() -> void:
	ghost.global_position = global_position + Vector2(0,1)
	ghost2.global_position = global_position + Vector2(0,2)
	ghost.rotation = rotation
	ghost2.rotation = rotation


func _on_shoot_timeout() -> void:
	if not player_node:
		return
		
	var player_pos := player_node.global_position
	var dir := self.global_position.direction_to(player_pos)
	
	var distance := 16
	var shift_pos := (dir * distance)
	var spawn_position := self.global_position + shift_pos
	
	var projectile_instance := projectile_scene.instantiate()
	projectile_instance.global_position = spawn_position
	projectile_instance.rotation = get_angle_to(player_pos)
	
	get_tree().current_scene.add_child(projectile_instance)

func _on_player_detection_body_entered(body: Node2D) -> void:
	if body is Player:
		player_node = body
		target_position = player_node.global_position
		direction = self.global_position.direction_to(target_position)

func _on_player_detection_body_exited(body: Node2D) -> void:
	if body is Player:
		player_node = null

func _on_pick_body_entered(body: Node2D) -> void:
	if body is Player:
		body.stored_number = value
		
		var particles_instance: GPUParticles2D = death_particles.instantiate()
		get_tree().current_scene.add_child(particles_instance)
		particles_instance.position = self.global_position
		
		queue_free()

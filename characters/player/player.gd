class_name Player
extends CharacterBody2D

@export_group("Internal Nodes")
@export var sprite : Sprite2D
@export var spawn_position: Marker2D
@export var projectile_scene: PackedScene

@export_group("Values")
@export var speed : float = 100
@export var run_speed : float = 125
@export var accel : float = 10
@export var deaccel : float = 8

var innit_speed : float
var last_dir : Vector2

var stored_number: int = -1

func handle_shoot() -> void:
	var projectile_instance := projectile_scene.instantiate()
	
	projectile_instance.number_value = stored_number
	
	projectile_instance.global_position = spawn_position.global_position
	projectile_instance.rotation = self.rotation
	
	get_tree().current_scene.add_child(projectile_instance)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		handle_shoot()

func move(delta : float) -> void:
	var dir : Vector2 = Input.get_vector("left","right","up","down")
	
	if dir:
		last_dir = dir
		velocity = lerp(velocity, dir * speed, delta * accel)
	else:
		velocity = lerp(velocity, Vector2.ZERO, delta * deaccel)

func _physics_process(delta: float) -> void:
	move(delta)
	
	var mouse_pos := get_global_mouse_position()
	look_at(mouse_pos)
	
	move_and_slide()

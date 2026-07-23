class_name Player
extends CharacterBody2D

@export_group("Internal Nodes")
@export var sprite : Sprite2D
@export var spawn_position: Marker2D
@export var projectile_scene: PackedScene
@export var ghost : Sprite2D
@export var ghost2 : Sprite2D

@export_group("Values")
@export var speed : float = 100
@export var accel : float = 10
@export var deaccel : float = 8

@export var cam_shake_force : Vector2 = Vector2(1,1)
@export var shake_time : float = 0.5

@export_group("Experimental")
@export var no_mouse: bool = false

var innit_speed : float
var last_dir : Vector2

var has_unshot_number: bool = false
var stored_number: int = -1:
	set(new_value):
		stored_number = new_value
		has_unshot_number = true
		PlayerGlobals.collected_number.emit(new_value)

func handle_shoot() -> void:
	var projectile_instance := projectile_scene.instantiate()
	
	projectile_instance.number_value = stored_number
	
	projectile_instance.global_position = spawn_position.global_position
	projectile_instance.rotation = self.rotation
	
	PlayerGlobals.camera_shake.emit(cam_shake_force,shake_time)
	recoil()
	get_tree().current_scene.add_child(projectile_instance)

	has_unshot_number = false
	PlayerGlobals.shoot_number.emit()

func handle_ghost() -> void:
	ghost.global_position = global_position + Vector2(0,1)
	ghost2.global_position = global_position + Vector2(0,2)
	ghost.rotation = rotation
	ghost2.rotation = rotation

func recoil() -> void:
	var mouse_dir : Vector2 = -global_position.direction_to(get_global_mouse_position())
	velocity += mouse_dir * speed

func _input(event: InputEvent) -> void:
	var can_shoot := event.is_action_pressed("shoot") and has_unshot_number
	if can_shoot:
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
	handle_ghost()
	if no_mouse:
		rotation = velocity.angle()
	else:
		var mouse_pos := get_global_mouse_position()
		look_at(mouse_pos)
	
	move_and_slide()

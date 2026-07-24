class_name Player
extends CharacterBody2D

enum move_states { UNDEFINED, FLYING, DASHING }
var movement_state: move_states

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

@export var dash_cooldown : float = 3
@export var dash_velocity : float = 30
@export var dash_duration : float = 0.3
var prev_velocity : Vector2
var can_dash : bool

var shoot_held : bool
var shoot_hold_duration : float
@export var charge_hold_duration : float = 1
@export var charge_shot_power : float = 2

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
	
	var power = charge_shot_power if shoot_hold_duration >= charge_hold_duration else 1.0
	projectile_instance.number_value = stored_number * power
	
	projectile_instance.global_position = spawn_position.global_position
	projectile_instance.rotation = self.rotation
	
	PlayerGlobals.camera_shake.emit(cam_shake_force,shake_time)
	PlayerGlobals.hitstop.emit(0.2,0.01)
	recoil()
	get_tree().current_scene.add_child(projectile_instance)

	has_unshot_number = false
	PlayerGlobals.shoot_number.emit()
	
	$sprite/ChargingShot.hide()
	$sprite/ChargedShot.hide()
	shoot_hold_duration = 0

func handle_ghost() -> void:
	ghost.global_position = global_position + Vector2(0,1)
	ghost2.global_position = global_position + Vector2(0,2)
	ghost.rotation = rotation
	ghost2.rotation = rotation

func recoil() -> void:
	var mouse_dir : Vector2 = -global_position.direction_to(get_global_mouse_position())
	velocity += mouse_dir * speed

func dash() -> void:
	can_dash = false
	prev_velocity = velocity
	movement_state = move_states.DASHING
	$DashCooldown.start(dash_cooldown)
	$DashStateExit.start(dash_duration)

func _input(event: InputEvent) -> void:
	#var can_shoot := event.is_action_pressed("shoot") and has_unshot_number
	#if can_shoot:
		#handle_shoot()
	if has_unshot_number:
		if event.is_action_pressed("shoot"):
			shoot_held = true
		elif event.is_action_released("shoot"):
			shoot_held = false
			handle_shoot()

func move(delta : float) -> void:
	var dir : Vector2 = Input.get_vector("left","right","up","down")
	var dashing = Input.is_action_just_pressed("dash")
	if dashing and can_dash:
		dash()
	
	if movement_state == move_states.DASHING:
		velocity = dir * dash_velocity
	elif movement_state == move_states.FLYING:
		if dir:
			last_dir = dir
			velocity = lerp(velocity, dir * speed, delta * accel)
		else:
			velocity = lerp(velocity, Vector2.ZERO, delta * deaccel)

func _ready():
	movement_state = move_states.FLYING
	prev_velocity = Vector2(0,0)
	can_dash = true

func _physics_process(delta: float) -> void:
	move(delta)
	handle_ghost()
	if no_mouse:
		rotation = velocity.angle()
	else:
		var mouse_pos := get_global_mouse_position()
		look_at(mouse_pos)
	
	move_and_slide()
	
	if shoot_held:
		shoot_hold_duration += delta
		if shoot_hold_duration < charge_hold_duration:
			$sprite/ChargingShot.show()
		else:
			$sprite/ChargingShot.hide()
			$sprite/ChargedShot.show()
	

func is_dashing():
	return movement_state == move_states.DASHING

func _on_dash_cooldown_timeout() -> void:
	can_dash = true

func _on_dash_state_exit_timeout() -> void:
	movement_state = move_states.FLYING
	velocity = prev_velocity

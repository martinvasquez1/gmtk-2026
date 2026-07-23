class_name Player
extends CharacterBody2D

@export_group("Internal Nodes")
##Sprite node.
@export var sprite : Sprite2D

@export_group("Values")
@export var speed : float = 100
@export var run_speed : float = 125
@export var accel : float = 10
@export var deaccel : float = 8

var innit_speed : float
var last_dir : Vector2

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

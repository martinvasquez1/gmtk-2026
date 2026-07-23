class_name EnemyNumber
extends CharacterBody2D

@export var label: Label

var value: int

func _ready() -> void:
	var random_num: int = randi_range(-9, 9)
	
	value = random_num
	label.text = str(value)

func _on_shoot_timeout() -> void:
	print("Spawn simple projectile")

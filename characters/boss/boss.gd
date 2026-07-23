class_name Boss
extends Node2D

@export var time_label: Label

var current_time_seconds: int = 100:
	set(new_value):
		current_time_seconds = new_value
		update_label()

func get_formatted_time(seconds) -> String:
	var m = int(seconds / 60.0)
	var s = seconds - m * 60
	return '%02d:%02d' % [m, s]

func update_label() -> void:
	var new_value = get_formatted_time(current_time_seconds)
	time_label.text = new_value

func _ready() -> void:
	BossGlobals.boss_node = self
	update_label()

func _on_one_second_timeout() -> void:
	current_time_seconds -= 1

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area is NumberProjectile:
		current_time_seconds += area.number_value

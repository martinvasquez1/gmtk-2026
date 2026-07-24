class_name Boss
extends Node2D

@export var time_label: Label

var current_time_seconds: int = 100:
	set(new_value):
		current_time_seconds = max(new_value, 0)
		update_label()

func update_label() -> void:
	var new_value = StringUtils.get_formatted_time(current_time_seconds)
	time_label.text = str(current_time_seconds)

func _ready() -> void:
	BossGlobals.boss_node = self
	update_label()

func _on_one_second_timeout() -> void:
	current_time_seconds -= 1

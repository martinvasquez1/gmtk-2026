extends Node


func _ready() -> void:
	PlayerGlobals.hitstop.connect(hitstop.bind())


func hitstop(ts : float, time : float) -> void:
	Engine.time_scale = ts
	await get_tree().create_timer(time).timeout
	Engine.time_scale = 1

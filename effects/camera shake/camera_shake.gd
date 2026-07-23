extends Camera2D


func _ready() -> void:
	PlayerGlobals.camera_shake.connect(camera_shake.bind())

func camera_shake(strength : Vector2, shake_time : float) -> void:
	var second_strength : Vector2 = strength * -1
	var tween : Tween = create_tween()
	
	tween.tween_property(self, "offset", strength, shake_time)
	tween.tween_property(self, "offset", second_strength, shake_time)
	tween.tween_property(self, "offset", Vector2.ZERO, shake_time)

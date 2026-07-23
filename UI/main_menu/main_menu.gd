extends CanvasLayer

func _input(event: InputEvent) -> void:
	if event is InputEvent and event.is_pressed():
		get_tree().change_scene_to_file("res://scenes/main.tscn")

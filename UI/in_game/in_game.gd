extends CanvasLayer

@export_group("Internal Nodes")
@export var label: Label

func _ready() -> void:
	PlayerGlobals.collected_number.connect(update_number_label)
	PlayerGlobals.shoot_number.connect(remove_label_number)

	label.text = ""

func remove_label_number() -> void:
	label.text = ""

func update_number_label(new_number: int) -> void:
	label.text = str(new_number)

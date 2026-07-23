extends CanvasLayer

@export_group("Internal Nodes")
@export var total_time_label: Label
@export var current_number_label: Label

var total_time_seconds: int = 0

func _ready() -> void:
	PlayerGlobals.collected_number.connect(update_number_label)
	PlayerGlobals.shoot_number.connect(remove_label_number)

	remove_label_number()
	update_total_time_label()

func remove_label_number() -> void:
	current_number_label.text = ""

func update_number_label(new_number: int) -> void:
	current_number_label.text = str(new_number)

func update_total_time_label() -> void:
	total_time_label.text = StringUtils.get_formatted_time(total_time_seconds)

func _on_one_second_timeout() -> void:
	total_time_seconds += 1
	update_total_time_label()

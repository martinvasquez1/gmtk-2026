extends Node

func get_formatted_time(seconds) -> String:
	var m = int(seconds / 60.0)
	var s = seconds - m * 60
	return '%02d:%02d' % [m, s]

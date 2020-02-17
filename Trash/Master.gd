extends Node2D

func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_released("ui_exit"):
		get_tree().quit(0);

extends Particles2D

func _input(event: InputEvent) -> void:
	if event.is_action_released("ui_exit"):
		get_tree().quit(0);

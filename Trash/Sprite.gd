extends Sprite

#onready var points_array := PoolVector2Array();
#onready var colors_array := PoolColorArray();
#onready var hue := randf();
#onready var glob_delta := 0.0;
#
#func _ready() -> void:
#	randomize();
#
#func _draw() -> void:
#	draw_rect(get_viewport_rect(), Color.black);
#	if(points_array.size() > 2 and colors_array.size() > 2):
#		draw_polyline_colors(points_array, colors_array, 16.0);
#
#func _input(event: InputEvent) -> void:
#	if event is InputEventMouseMotion:
#		points_array.append(get_global_mouse_position());
#		colors_array.append(Color().from_hsv(hue, 1.0, 1.0));
#		hue = fmod(hue + glob_delta * 0.1, 1.0);
#
func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_released("ui_exit"):
		get_tree().quit();
#
#func _process(_delta: float) -> void:
#	glob_delta = _delta;
#	update();
#
#	if Input.is_key_pressed(KEY_C):
#		points_array.resize(0);
#		colors_array.resize(0);

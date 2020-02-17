extends Sprite

onready var zoom_level : float = material.get_shader_param("ZOOM_AMOUNT");
onready var prev_zoom_level : float = zoom_level;
var time : float = 0.0;
const reset_on_zoom_change : bool = false;

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("scroll_up")):
		zoom_level -= 0.0125;
		material.set_shader_param("ZOOM_AMOUNT", zoom_level);
	elif(event.is_action_pressed("scroll_down")):
		zoom_level += 0.0125;
		material.set_shader_param("ZOOM_AMOUNT", zoom_level);

func _process(delta: float) -> void:
	if(reset_on_zoom_change):
		zoom_level = material.get_shader_param("ZOOM_AMOUNT");
		if(!is_equal_approx(prev_zoom_level, zoom_level)):
			prev_zoom_level = zoom_level;
			time = 0.0;
	time += delta;
	material.set_shader_param("time", time);

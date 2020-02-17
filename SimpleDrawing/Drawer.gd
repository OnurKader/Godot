extends Node2D

onready var mouse := get_viewport().get_mouse_position();
var image : Image = Image.new();
var render_texture : ImageTexture = ImageTexture.new();
const MAX_ITER := 52;
var x_min := -2.5;
var x_max := 1.5;
var y_min := -2.0;
var y_max := 2.0;

var prev_x_min := x_min;
var prev_x_max := x_max;
var prev_y_min := y_min;
var prev_y_max := y_max;

func map(value, min_dom, max_dom, min_ran, max_ran):
	return ((value - min_dom) * (max_ran - min_ran) / (max_dom - min_dom) + min_ran);

func _ready() -> void:
#	image.create(640, 640, false, Image.FORMAT_RGBA8);
#	updateImage();
#	render_texture.create_from_image(image);
	pass;

func updateImage() -> void:
	image.lock();
	for y in image.get_height():
		for x in image.get_width():
			var a = map(x, 0.0, image.get_width(), x_min, x_max);
			var b = map(y, 0.0, image.get_height(), y_min, y_max);
			var count = 0;

			var prev_a = a;
			var prev_b = b;

			while(count < MAX_ITER):
				var temp = a;
				a = a*a - b*b + prev_a;
				b = 2 * temp * b + prev_b;

				if(a*a + b*b > 2.0):
					break;
				count += 1;

			var brightness = map(count, 0.0, MAX_ITER, 0.0, 1.0);
			brightness = map(sqrt(brightness), 0.0, 1.0, 0.0, 255.0);
			if(count == MAX_ITER):
				brightness = 0.0;
			image.set_pixel(x, y, Color8(brightness, brightness, brightness));

	image.unlock();

func _input(event: InputEvent) -> void:
	if(event.is_action_released("exit")):
		get_tree().quit();
	if(event is InputEventMouseMotion):
		mouse = event.position;

func _draw() -> void:
	draw_texture(render_texture, Vector2());

func _process(_delta):
#	update();
#	x_min *= 0.95;
#	y_min *= 0.95;
#	x_max *= 0.95;
#	y_max *= 0.95;
#	if(x_min != prev_x_min or y_min != prev_y_min or x_max != prev_x_max or y_max != prev_y_max):
#		updateImage();
#		render_texture.create_from_image(image);
#		prev_x_min = x_min;
#		prev_x_max = x_max;
#		prev_y_min = y_min;
#		prev_y_max = y_max;
	pass

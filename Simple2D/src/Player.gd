extends KinematicBody2D;

class_name Player

onready var image : Sprite = get_node("Sprite");
export var movement_speed := 175.0;
onready var screen_size := get_viewport_rect().size;

func _ready() -> void:
	pass;

func _unhandled_key_input(event: InputEventKey) -> void:
	if(event.is_action_released("ui_cancel")):
		get_tree().quit(0);

func _physics_process(_delta: float) -> void:
	var vel := Vector2.ZERO;
	if Input.is_action_pressed("ui_left"):
		vel.x += -1.0;
	elif Input.is_action_pressed("ui_right"):
		vel.x += 1.0;
	if Input.is_action_pressed("ui_up"):
		vel.y += -1.0;
	elif Input.is_action_pressed("ui_down"):
		vel.y += 1.0;

	if(vel.length() > 0.0):
		vel = vel.normalized() * movement_speed;

	if(vel.x != 0.0):
		image.flip_h = vel.x > 0.0;

	position += vel * _delta;
	position.x = clamp(position.x, 0.0, screen_size.x);
	position.y = clamp(position.y, 0.0, screen_size.y);


extends KinematicBody2D

export (Vector2) var movement_speed;

func _physics_process(delta: float) -> void:
	if Input.is_key_pressed(KEY_W):
		position.y -= movement_speed.y * delta;
	if Input.is_key_pressed(KEY_S):
		position.y += movement_speed.y * delta;

	if Input.is_key_pressed(KEY_A):
		position.x -= movement_speed.x * delta;
	if Input.is_key_pressed(KEY_D):
		position.x += movement_speed.x * delta;

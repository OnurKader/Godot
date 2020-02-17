extends Area2D;
signal hit;

export var speed: float = 200.0;
var screen_size;

func start(pos):
	position = pos;
	show();
	$CollisionShape2D.disabled = false;

func _ready():
	screen_size = get_viewport_rect().size;
	hide();

func _process(delta):
	var velocity = Vector2();  # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1;
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= 1;
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1;
	elif Input.is_action_pressed("ui_down"):
		velocity.y += 1;

	if Input.is_key_pressed(KEY_Q) or Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit();

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed;
		$AnimatedSprite.play();
	else:
		$AnimatedSprite.stop();

	position += velocity * delta;
	position.x = clamp(position.x, 0, screen_size.x);
	position.y = clamp(position.y, 0, screen_size.y);

	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0


func _on_Player_body_entered(body):
	emit_signal("hit");
	hide();
	$CollisionShape2D.set_deferred("disabled", true);


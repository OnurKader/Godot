extends RigidBody2D

export var min_speed = 125;  # Minimum speed range.
export var max_speed = 225;  # Maximum speed range.
var mob_types = ["fly", "swim", "walk"];

func _ready():
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()];

func _process(delta):
	pass


func _on_Visibility_screen_exited():
	queue_free();

func _on_start_game():
	queue_free();

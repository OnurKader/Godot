extends Node;

export (PackedScene) var Mob;
var score: int = 0;

func _ready():
	randomize();


func gameOver():
	$ScoreTimer.stop();

	$MobTimer.stop();
	score = 0;
	$HUD.showGameOver();
	$HUD.updateScore(score);

func new_game():
	score = 0;
	$Player.start($StartPosition.position);
	$StartTimer.start();
	$HUD.updateScore(score);
	$HUD.showMessage("Get Ready!");

func _on_StartTimer_timeout():
	$MobTimer.start();
	$ScoreTimer.start();

func _on_ScoreTimer_timeout():
	score += 1;
	$HUD.updateScore(score);

func _on_MobTimer_timeout():
	$MobPath/MobSpawnLocation.set_offset(randi());
	var mob = Mob.instance();
	add_child(mob);

	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2.0;
	mob.position = $MobPath/MobSpawnLocation.position;

	direction += rand_range(-PI / 4.0, PI / 4.0);
	mob.rotation = direction;

	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0);
	mob.linear_velocity = mob.linear_velocity.rotated(direction);

	$HUD.connect("start_game", mob, "_on_start_game");

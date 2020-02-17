extends CanvasLayer;

signal start_game;

func showMessage(text):
	$MessageLabel.text = text;
	$MessageLabel.show();
	$MessageTimer.start();

func showGameOver():
	showMessage("Game Over!");
	yield($MessageTimer, "timeout");

	$MessageLabel.text = "AAAAAAHHHH\nRUN";
	$MessageLabel.show();

	yield(get_tree().create_timer(1), "timeout");
	$StartButton.show();

func updateScore(score):
	$ScoreLabel.text = "Score: " + str(score);

func _on_StartButton_pressed():
	$StartButton.hide();
	emit_signal("start_game");

func _on_MessageTimer_timeout():
	$MessageLabel.hide();

extends Control;

onready var time_label : Label = get_node("TimeLabel");
onready var time_timer : Timer = get_node("TimeTimer");
onready var game_over_label : Label = get_node("GameOverLabel");
onready var replay_button : Button = get_node("Button");
enum GameState {NOT_OVER = -1, O_WON, X_WON, DRAW};
var time_passed := 0;

func _ready():
	time_timer.start();

func displayGameState(game_state: int) -> void:
#	if(current_game_state == GameState.NOT_OVER):
#		return;
	if(game_state == GameState.X_WON):
		game_over_label.text = game_over_label.text % 'X';
	elif(game_state == GameState.O_WON):
		game_over_label.text = game_over_label.text % 'O';
	elif(game_state == GameState.DRAW):
		game_over_label.text = "DRAW!";
	game_over_label.visible = true;

func _on_timeout() -> void:
	time_passed += 1;
	time_label.text = "Time: %d" % time_passed;

func _on_UI_game_over(state) -> void:
	yield(get_tree().create_timer(get_parent().end_delay), "timeout");
	time_timer.stop();
	replay_button.visible = true;
	displayGameState(state);


func _on_Button_pressed() -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/Main.tscn");

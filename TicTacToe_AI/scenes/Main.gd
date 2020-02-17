extends Node2D;
signal game_over(state);

onready var tilemap     := get_node("Grid Cells");
onready var time_label  := get_node("UI/TimeLabel");
onready var tile_sprite := get_node("Tile");
enum GameState {NOT_OVER = -1, O_WON, X_WON, DRAW};
enum Player {O, X};
const MinimaxScores := [0, -10, 10, 0];
var current_game_state : int = GameState.NOT_OVER;
var turn : int;
const ERR_VEC := Vector2(-1, -1);
export var end_delay := 0.166;
onready var failsafe := true;

func _ready() -> void:
	set_process(true);
	set_process_input(true);
	turn = Player.X;

func toggleTurn() -> void:
	turn = Player.O if (turn == Player.X) else Player.X;

func getTileCell(row: int, col: int) -> int:
	return tilemap.get_cell(col, row);

func getTileCellv(cell_vec: Vector2) -> int:
	return tilemap.get_cellv(Vector2(cell_vec.y, cell_vec.x));

func isRowFilled(row_id: int) -> int:
	if(getTileCell(row_id, 0) == getTileCell(row_id, 1) and
	   getTileCell(row_id, 1) == getTileCell(row_id, 2)):
		if(getTileCell(row_id, 0) == Player.X):
			return GameState.X_WON;
		if(getTileCell(row_id, 0) == Player.O):
			return GameState.O_WON;

	return GameState.NOT_OVER;

func isColFilled(col_id: int) -> int:
	if(getTileCell(0, col_id) == getTileCell(1, col_id) and
	   getTileCell(1, col_id) == getTileCell(2, col_id)):
		if(getTileCell(0, col_id) == Player.X):
			return GameState.X_WON;
		if(getTileCell(0, col_id) == Player.O):
			return GameState.O_WON;

	return GameState.NOT_OVER;

func isDiagFilled(forward_slash: int) -> int:
	if(forward_slash == 0):		# It's a backslash, going from top left to bottom right
		if(getTileCell(0, 0) == getTileCell(1, 1) and
		   getTileCell(1, 1) == getTileCell(2, 2)):
			if(getTileCell(1, 1) == Player.X):
				return GameState.X_WON;
			if(getTileCell(1, 1) == Player.O):
				return GameState.O_WON;
		return GameState.NOT_OVER;
	else:
		if(getTileCell(2, 0) == getTileCell(1, 1) and
		   getTileCell(1, 1) == getTileCell(0, 2)):
			if(getTileCell(1, 1) == Player.X):
				return GameState.X_WON;
			if(getTileCell(1, 1) == Player.O):
				return GameState.O_WON;
		return GameState.NOT_OVER;

func isDrawState() -> bool:
	return isBoardFilled();

func isGameOver() -> void:
	for i in 3:
		var row_info := isRowFilled(i);
		var col_info := isColFilled(i);
		if(row_info == GameState.NOT_OVER and col_info == GameState.NOT_OVER):
			current_game_state = GameState.NOT_OVER;
		elif(row_info != GameState.NOT_OVER):
			current_game_state = row_info;
			return;
		elif(col_info != GameState.NOT_OVER):
			current_game_state = col_info;
			return;

	for i in 2:
		var diag_info := isDiagFilled(i);
		if(diag_info == GameState.NOT_OVER):
			current_game_state = GameState.NOT_OVER;
		else:
			current_game_state = diag_info;
			return;
	if(isDrawState()):
		current_game_state = GameState.DRAW;
	else:
		current_game_state = GameState.NOT_OVER;

func isBoardFilled() -> bool:
	for i in 3:
		for j in 3:
			if(isCellEmpty(i, j)):
				return false;
	return true;

func isMousePressed(event: InputEvent, button_id: int) -> bool:
	return (event is InputEventMouseButton and
		event.button_index == button_id and
		event.is_pressed());

func _input(event: InputEvent) -> void:
	if isMousePressed(event, BUTTON_LEFT):
		var clicked_cell := getTileCellFromMouse(event.position);
		if(turn == Player.O):	# Player's turn
			playHuman(clicked_cell);

func setTileCell(row: float, col: float, tile: int):
	tilemap.set_cell(col, row, tile);
	isGameOver();
	if(current_game_state != GameState.NOT_OVER):
		emit_signal("game_over", current_game_state);

func isCellEmpty(row: int, col: int) -> bool:
	return (tilemap.get_cell(col, row) == -1);

func isCellEmptyV(cell: Vector2) -> bool:
	return (tilemap.get_cellv(Vector2(cell.y, cell.x)) == -1);

func playHuman(cell: Vector2) -> void:
	if current_game_state == GameState.NOT_OVER and cell != ERR_VEC and isCellEmptyV(cell):
		setTileCell(cell.x, cell.y, turn);
		toggleTurn();

func playAI() -> void:
	print("I'M the spy'");
	bestMove();

func getWinner() -> int:
	var result : int;
	for i in 3:
		var row_info := isRowFilled(i);
		var col_info := isColFilled(i);
		if(row_info == GameState.NOT_OVER and col_info == GameState.NOT_OVER):
			result = GameState.NOT_OVER;
		elif(row_info != GameState.NOT_OVER):
			return row_info;
		elif(col_info != GameState.NOT_OVER):
			return col_info;

	for i in 2:
		var diag_info := isDiagFilled(i);
		if(diag_info == GameState.NOT_OVER):
			result = GameState.NOT_OVER;
		else:
			return diag_info;

	if(isDrawState()):
		return GameState.DRAW;
	else:
		result = GameState.NOT_OVER;

	return result;

func bestMove() -> void:
	var best_score := -INF;
	var move := Vector2();
	for i in 3:
		for j in 3:
			if isCellEmpty(i, j):
				setTileCell(i, j, Player.X);
				var score = minimax(Player.O);
				setTileCell(i, j, -1);
				if(score > best_score):
					best_score = score;
					move.x = i;
					move.y = j;

	setTileCell(move.x, move.y, Player.X);
	toggleTurn();

func minimax(next_turn: int):
	var winner := getWinner();
	if(winner != GameState.NOT_OVER):
		return MinimaxScores[winner + 1];

	if(next_turn == Player.X):
		var best_score := -INF;
		for i in 3:
			for j in 3:
				if isCellEmpty(i, j):
					setTileCell(i, j, next_turn);
					var score = minimax(Player.O);
					setTileCell(i, j, -1);
					best_score = max(score, best_score);
		return best_score;
	else:
		var best_score = INF;
		for i in 3:
			for j in 3:
				if isCellEmpty(i, j):
					setTileCell(i, j, next_turn);
					var score = minimax(Player.X);
					setTileCell(i, j, -1);
					best_score = min(score, best_score);
		return best_score;

func getTileCellFromMouse(mouse_vector: Vector2) -> Vector2:
	if mouse_vector.y < tilemap.position.y ||\
		mouse_vector.y > tilemap.position.y + 3*tilemap.cell_size.y:
		return ERR_VEC;
	for i in 3:
		for j in 3:
			var cell = Rect2(tilemap.position.x + j * tilemap.cell_size.x,
				tilemap.position.y + i * tilemap.cell_size.y,
				tilemap.cell_size.x, tilemap.cell_size.y);
			if cell.has_point(mouse_vector):
				return Vector2(i, j);
	return ERR_VEC;

func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_Q) or Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit();
	elif(failsafe and turn == Player.X and Input.is_key_pressed(KEY_ENTER) or Input.is_key_pressed(KEY_SPACE)):
		print("Just print the fuckimg strngi")
		failsafe = false;
		playAI();

func _on_game_over(_state) -> void:
	yield(get_tree().create_timer(end_delay), "timeout");
	tile_sprite.visible = false;
	tilemap.visible = false;

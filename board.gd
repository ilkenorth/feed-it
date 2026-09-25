extends Node2D

@export var width: int = 8
@export var height: int = 10
@export var offset: int = 64
@export var piece_scene: PackedScene

var possible_colors = [Color.RED, Color.GREEN, Color.BLUE, Color.YELLOW, Color.PURPLE, Color.ORANGE]

var grid: Array = []

func _ready():
	make_2d_array()
	spawn_pieces()

func make_2d_array():
	for column in width:
		grid.append([])
		for row in height:
			grid[column].append(null)

func spawn_pieces():
	for column in width:
		for row in height:
			var random_color = possible_colors.pick_random()
			while match_at(column, row, random_color):
				random_color = possible_colors.pick_random()
			var piece = piece_scene.instantiate()
			add_child(piece)
			piece.position = Vector2(column * offset, row * offset)
			piece.get_node("Sprite2D").modulate = random_color
			piece.column = column
			piece.row = row
			grid[column][row] = piece

func match_at(column, row, color) -> bool:
	if column > 1:
		if grid[column - 1][row] != null and grid[column - 2][row] != null:
			if grid[column - 1][row].get_node("Sprite2D").modulate == color and grid[column - 2][row].get_node("Sprite2D").modulate == color:
				return true
	if row > 1:
		if grid[column][row - 1] != null and grid[column][row - 2] != null:
			if grid[column][row - 1].get_node("Sprite2D").modulate == color and grid[column][row - 2].get_node("Sprite2D").modulate == color:
				return true
	return false

func swap_pieces(column, row, direction):
	var new_col = column + direction.x
	var new_row = row + direction.y
	if new_col >= 0 and new_col < width and new_row >= 0 and new_row < height:
		var first_piece = grid[column][row]
		var other_piece = grid[new_col][new_row]
		if first_piece != null and other_piece != null:
			grid[column][row] = other_piece
			grid[new_col][new_row] = first_piece
			first_piece.column = new_col
			first_piece.row = new_row
			other_piece.column = column
			other_piece.row = row
			first_piece.move(Vector2(first_piece.column * offset, first_piece.row * offset))
			other_piece.move(Vector2(other_piece.column * offset, other_piece.row * offset))

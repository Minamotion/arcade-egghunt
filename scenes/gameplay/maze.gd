extends TileMapLayer


const DIRECTIONS: PackedVector2Array= [
	Vector2i.LEFT *2,
	Vector2i.RIGHT *2,
	Vector2i.DOWN *2,
	Vector2i.UP *2
]


var rng: RandomNumberGenerator


var maze: Array= []
var rows: int
var cols: int


func _ready() -> void:
	#region [Setup RNG]
	print("Setting up RNG...")
	randomize()
	
	rng = RandomNumberGenerator.new()
	rng.seed = randi()
	#endregion
	#region [Setup maze]
	print("Setting up maze...")
	rows = rng.randi_range(12, 48)
	cols = rng.randi_range(12, 48)
	
	for r in range(rows):
		var row = []
		for c in range(cols):
			row.append(0)
		maze.append(row)
	var start: Vector2i= Vector2i(
		rng.randi_range(1, cols -1),
		rng.randi_range(1, rows -1)
	)
	maze[start.y][start.x] = 1
	print(str("This maze will be a ", rows, "x", cols, " maze"))
	#endregion
	#region [Generating maze]
	print("Generating maze...")
	carve_paths(start)
	for r in range(rows):
		for c in range(cols):
			var pos: Vector2i= Vector2i(c, r)
			set_cell(pos, 0, Vector2i(0, maze[r][c] *2))
	#endregion
	#region [Clean up maze]
	print("Cleaning up...")
	for r in range(rows):
		for c in range(cols):
			var pos: Vector2i= Vector2i(c, r)
			if maze[r][c] == 0:
				#region [Setup walls]
				var bottom_cell = get_cell_tile_data(pos +Vector2i.DOWN)
				if bottom_cell == null:
					continue
				var top_cell = get_cell_tile_data(pos +Vector2i.UP)
				if top_cell == null:
					continue
				var side_cells: Array[TileData]= []
				for direction in [Vector2i.LEFT, Vector2i.RIGHT]:
					var cell = get_cell_tile_data(pos +direction)
					if cell != null: side_cells.append(cell)
				if bottom_cell.get_custom_data("isEggable"):
					if (
						rng.randi_range(1,20) <= 4
						and top_cell.get_custom_data("isEggable")
						and side_cells.all(func(cell): return not cell.get_custom_data("isEggable"))
					):
						set_cell(pos, 0, Vector2i(0, 2))
					else:
						set_cell(pos, 0, Vector2i(0, 1))
				#endregion
	#endregion
	print("Maze has been generated!\n")

func carve_paths(pos: Vector2i):
	var directions = DIRECTIONS.duplicate() as Array
	directions.shuffle()
	for direction in directions:
		var lnext = pos +Vector2i(direction.x /2, direction.y /2)
		var next = pos +Vector2i(direction)
		if (
			(next.x > 0 and next.x < cols -1)
			and (next.y > 0 and next.y < rows -1)
			and maze[next.y][next.x] == 0
		):
			maze[lnext.y][lnext.x] = 1
			maze[next.y][next.x] = 1
			carve_paths(next)

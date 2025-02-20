extends Spatial

const CELL_SIZE = 2
const MAZE_WIDTH = 25
const MAZE_HEIGHT = 25
export(PackedScene) var wall_scene
export(PackedScene) var character_scene

var maze = []
var stack = []
var visited = {}

func _ready():
	randomize()
	generate_maze()
	create_maze_mesh()
	spawn_character()

func generate_maze():
	maze = []
	for y in range(MAZE_HEIGHT):
		maze.append([])
		for x in range(MAZE_WIDTH):
			maze[y].append(1)
	
	var start_x = 1
	var start_y = 1
	stack.append(Vector2(start_x, start_y))
	visited[Vector2(start_x, start_y)] = true
	maze[start_y][start_x] = 0
	
	while stack.size() > 0:
		var current = stack[-1]
		var neighbors = get_unvisited_neighbors(current)
		
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()]
			remove_wall_between(current, next)
			stack.append(next)
			visited[next] = true
			maze[next.y][next.x] = 0
		else:
			stack.pop_back()

func get_unvisited_neighbors(cell):
	var neighbors = []
	var directions = [Vector2(0, -2), Vector2(2, 0), Vector2(0, 2), Vector2(-2, 0)]
	for dir in directions:
		var neighbor = cell + dir
		if is_inside_maze(neighbor) and !visited.has(neighbor):
			neighbors.append(neighbor)
	return neighbors

func remove_wall_between(a, b):
	var wall_pos = (a + b) / 2
	maze[wall_pos.y][wall_pos.x] = 0

func is_inside_maze(cell):
	return cell.x > 0 and cell.x < MAZE_WIDTH - 1 and cell.y > 0 and cell.y < MAZE_HEIGHT - 1

func create_maze_mesh():
	for y in range(MAZE_HEIGHT):
		for x in range(MAZE_WIDTH):
			if maze[y][x] == 1:
				var wall = wall_scene.instance()
				wall.transform.origin = Vector3(x * CELL_SIZE, 0, y * CELL_SIZE)
				add_child(wall)

func spawn_character():
	if character_scene:
		var character = character_scene.instance()
		var center_x = int(MAZE_WIDTH / 2) * CELL_SIZE
		var center_y = int(MAZE_HEIGHT / 2) * CELL_SIZE
		character.transform.origin = Vector3(center_x, 0, center_y)
		add_child(character)

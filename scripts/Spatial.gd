extends Spatial

const MAZE_SIZE = 55  # Small size
var maze = []
var cell_size = 2.0  # Adjust spacing between walls
var rng = RandomNumberGenerator.new()
var directions = [Vector2(0, 1), Vector2(1, 0), Vector2(0, -1), Vector2(-1, 0)]

onready var wall_scene = preload("res://scenes/Wall.tscn")
onready var character_scene = preload("res://scenes/NewFPS.tscn")

func _ready():
	rng.randomize()
	generate_maze()
	create_maze_mesh()
	place_character()

func generate_maze():
	maze = []
	for x in range(MAZE_SIZE):
		maze.append([])
		for y in range(MAZE_SIZE):
			maze[x].append(true)  # True means a wall exists

	var stack = []
	var start = Vector2(0, 0)  # Start at the origin
	stack.append(start)
	maze[start.x][start.y] = false  # Mark as path

	while stack:
		var current = stack[-1]
		var neighbors = []
		for d in directions:
			var nx = current.x + d.x * 2
			var ny = current.y + d.y * 2
			if nx >= 0 and ny >= 0 and nx < MAZE_SIZE and ny < MAZE_SIZE and maze[nx][ny]:
				neighbors.append(Vector2(nx, ny))
		
		if neighbors.size() > 0:
			var next = neighbors[rng.randi() % neighbors.size()]
			maze[next.x][next.y] = false  # Mark as path
			maze[int((current.x + next.x) / 2)][int((current.y + next.y) / 2)] = false  # Remove wall between
			stack.append(next)
		else:
			stack.pop_back()

func create_maze_mesh():
	var offset = Vector3(-((MAZE_SIZE - 1) * cell_size) / 2, 0, -((MAZE_SIZE - 1) * cell_size) / 2)
	for x in range(MAZE_SIZE):
		for y in range(MAZE_SIZE):
			if maze[x][y]:
				var wall = wall_scene.instance()
				wall.translation = Vector3(x * cell_size, 0, y * cell_size) + offset
				add_child(wall)

func place_character():
	var character = character_scene.instance()
	character.translation = Vector3(0, 0, 0)  # Place character at the origin
	add_child(character)

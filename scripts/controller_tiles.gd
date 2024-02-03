extends Node2D
## Control game tiles and your attributes/properties

class_name ControllerTiles

const WIDTH = 6
const HEIGHT = 8
const tile_scene = preload("res://game_tile.tscn")

var tiles: Array = []
var astar_grid: AStarGrid2D = AStarGrid2D.new()

signal tile_created(tile: GameTile)

func _ready():
	_init_astar_grid()
	for row in WIDTH:
		for column in HEIGHT:
			instantiate_tile(row, column)
			
func _init_astar_grid():
	astar_grid.region = Rect2i(0, 0, 128, 128)
	astar_grid.cell_size = GameCharacter.DEFAULT_SIZE
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()

func instantiate_tile(x: int, y: int):
	var instance = tile_scene.instantiate()
	var final_position = (Vector2(x, y) + Vector2.ONE) * GameCharacter.DEFAULT_SIZE
	instance.global_position = final_position
	tiles.append(instance)
	add_child(instance)
	tile_created.emit(instance)

func get_tile_from_position(pos: Vector2):
	var tiles_on_pos = tiles.filter(func(t): return t.position == pos.round())
	if not tiles_on_pos.is_empty():
		return tiles_on_pos[0] as GameTile

func path_line(from: Vector2, to: Vector2):
	var default_size = GameCharacter.DEFAULT_SIZE
	from = (from / default_size) - Vector2.ONE
	to = (to / default_size) - Vector2.ONE
	# TODO ignore ocuuped
#	astar_grid.set_point_solid(Vector2i(1,1))
#	astar_grid.set_point_solid(Vector2i(1,2))
	var points = astar_grid.get_id_path(from, to).map(func(p): return Vector2(p) * default_size)
	#line.position = default_size * 1.5 # Multiply to center
	#line.points = points
	return points.map(func(p): return p + default_size)

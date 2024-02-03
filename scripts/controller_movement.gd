extends Node2D

class_name ControllerMovement

@export var controller_pieces: ControllerPieces
@export var controller_tiles: ControllerTiles

var moving := 0

signal movement_ended(character: GameCharacter)

func _ready():
	if controller_pieces == null or controller_tiles == null:
		push_error("Please attach a controller_pieces and a controller_tiles to this controller")
	else:
		controller_pieces.active_changes.connect(on_active_changes)
		controller_pieces.piece_removed.connect(on_piece_removed)
		
func _process(_delta):
	var active_piece = controller_pieces.active_piece
	
	if Input.is_action_just_released("ui_interact") and active_piece:
		stop_moving()
	
	if controller_pieces.active_piece == null:
		return
	
	active_piece.move_slide(get_global_mouse_position())

func on_active_changes(new: GameCharacter, old: GameCharacter):
	pass

func on_piece_removed(piece: GameCharacter):
	print("controller_movement ", piece)
	
func bound_piece(piece: GameCharacter):
	var tile = get_tile_from_position(piece.actual_position())
	
	if tile == null:
		return
		
	bound_piece_tile(piece, tile)
	
func bound_piece_tile(piece: GameCharacter, tile: GameTile):
	tile.metadata.piece = piece

func get_tile_from_position(pos: Vector2):
	var tiles_on_pos = controller_tiles.tiles.filter(func(t): return t.position == pos.round())
	if not tiles_on_pos.is_empty():
		return tiles_on_pos[0] as GameTile
		
func stop_moving():
	var piece = controller_pieces.active_piece
	piece.move_and_snap(get_global_mouse_position())
	controller_pieces.active_piece = null
	movement_ended.emit(piece)

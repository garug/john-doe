extends Node2D

class_name ControllerCharacterTile

@export var controller_tiles: ControllerTiles
@export var controller_characters: ControllerPieces

var last_position: Vector2

func _ready():
	if controller_characters == null or controller_tiles == null:
		push_error("Please attach a controller_pieces and a controller_tiles to this controller")
	else:
		controller_tiles.tile_created.connect(_on_tile_created)
		controller_characters.active_changes.connect(_on_active_changes)
		controller_characters.piece_created.connect(_on_character_created)

func _on_touch(tile: GameTile, character: GameCharacter):
	var inner_character = tile.metadata.get("piece")
	var is_ai = character.participant is AIParticipant

	if inner_character == character:
		pass
	elif inner_character == null and not is_ai:
		set_last_position(tile.position)
	elif controller_characters.active_piece == character:
		move_piece(tile)
		set_last_position(tile.position)
	elif is_ai:
		bound_piece_tile(character, tile)
	else:
		move_piece(tile)
		bound_piece_tile(character, tile)

func set_last_position(pos: Vector2):
	last_position = pos

func _on_tile_created(tile: GameTile):
	tile.touched.connect(_on_touch)
	
func _on_active_changes(new_value, old_value):
	if new_value == null:
		_on_character_released(old_value)
	elif old_value == null and new_value != null:
		_on_character_touched(new_value)
	else:
		print("on_active_changes: not implemented change - ", new_value, old_value)
		
func _on_character_created(character: GameCharacter):
	bound_piece(character)
#	piece.die.connect(on_piece_die)

func _on_character_released(piece: GameCharacter):
	var tile = controller_tiles.get_tile_from_position(piece.actual_position())
	var inner_piece = tile.metadata.get("piece")
	if inner_piece == null:
		bound_piece(piece)

func _on_character_touched(piece: GameCharacter):
	set_last_position(piece.actual_position())
	unbound_character(piece)

func bound_piece(piece: GameCharacter):
	var tile = controller_tiles.get_tile_from_position(piece.actual_position())
	
	if tile == null:
		return

	bound_piece_tile(piece, tile)

func bound_piece_tile(character: GameCharacter, tile: GameTile):
	tile.metadata.piece = character

func move_piece(tile: GameTile):
	if last_position == null:
		return
	var piece: GameCharacter = tile.metadata.get("piece")
	unbound_tile(tile)
	var last_tile = controller_tiles.get_tile_from_position(last_position)
	bound_piece_tile(piece, last_tile)
	if (piece != null):
		piece.tween_position(last_position)

func unbound_character(piece: GameCharacter):
	var tile = controller_tiles.get_tile_from_position(piece.actual_position())

	if tile == null:
		return

	unbound_tile(tile)

func unbound_tile(tile: GameTile):
	tile.metadata.erase("piece")

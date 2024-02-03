extends Participant

class_name AIParticipant

func act():
	var enemies :Array[GameCharacter] = controller_pieces.get_from_same_team_by_number(enemy.id)
	var characters = controller_pieces.get_from_same_team_by_number(id)
	
	for character in characters:
		await act_character(character, enemies)
	#await get_tree().process_frame
	#for enemy in enemies:
		#var tiles_walked = _recursive_path(enemy.moves, enemy.actual_position())
		#var tiles_astar = _astar_path(enemy.moves, enemy)
		##enemy.do_actions(controller_tiles)
	#print("enemies", enemies)
	controller_turn.turn_end()

func act_character(character: GameCharacter, enemies: Array[GameCharacter]):
	for enemy in enemies:
		var tiles_walked = _astar_path(enemy.moves, character)
		print("tiles", tiles_walked)
	await move(character, enemies)
	attack(character, enemies)
	await get_tree().create_timer(.05).timeout

func init(movement: ControllerMovement, pieces: ControllerPieces, turn: ControllerTurn, tiles: ControllerTiles):
	controller_movement = movement
	controller_pieces = pieces
	controller_turn = turn
	controller_tiles = tiles
	controller_turn.turn_started.connect(_on_turn_start)

func _on_turn_start(turn_number: int, participant: Participant):
	if participant.id == id:
		act()
		
func _astar_path(steps: int, user: GameCharacter):
	var enemies = controller_tiles.tiles\
		.map(func(tile): return tile.metadata.get("piece"))\
		.filter(func(piece): return piece != null)\
		.filter(func(piece): return piece.participant != user.participant)
	
# TODO get closest enemy instead of first
	var astar_grid = controller_tiles.path_line(user.actual_position(), enemies[0].actual_position())
	print("slice", user, astar_grid.slice(1, user.moves))
#	return tiles_walked

func _recursive_path(steps: int, base_position: Vector2, prev: Array = []):
	var tiles_walked := {}
	
	for dir in Directions.cardial():
		var pos = Vector2(dir) * GameCharacter.DEFAULT_SIZE + base_position
		var tile = controller_tiles.get_tile_from_position(pos)
		if tile != null:
			tiles_walked[tile] = prev + [tile]
	
	if steps > 1:
		for tile in tiles_walked.keys():
			tiles_walked.merge(_recursive_path(steps - 1, tile.position, tiles_walked[tile]))
		
	return tiles_walked

func move(character: GameCharacter, targets: Array[GameCharacter]):
	# TODO find best place to move, depends type of attack
	#var target = targets[0].actual_position()
	var target = character.actual_position() + Vector2(0, 2) * GameCharacter.DEFAULT_SIZE
	print("Character moving", character.actual_position(), target)
	var movement = character.tween_position(target)
	return movement.finished

func attack(character: GameCharacter, targets: Array[GameCharacter]):
	#print("Character attacking ", character, targets)
	pass

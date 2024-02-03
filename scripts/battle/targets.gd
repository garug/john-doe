extends Node

class_name Targets

static func meele(user: GameCharacter, controller_tiles: ControllerTiles):
	return _common_targets(user, controller_tiles, func(dir):
		var pos = Vector2(dir) * GameCharacter.DEFAULT_SIZE + user.actual_position()
		var tile = controller_tiles.get_tile_from_position(pos)
		if tile != null:
			return tile.metadata.get("piece"))

static func distance(user: GameCharacter, controller_tiles: ControllerTiles):
	return []
	
static func magic(user: GameCharacter, controller_tiles: ControllerTiles):
	return []
	
static func _common_targets(user: GameCharacter, controller_tiles: ControllerTiles, map_fn):
	return Callable(Directions, user.attack_directions).call()\
		.map(map_fn)\
		.filter(func(c): return c)\
		.filter(func(c): return c.participant.id != user.participant.id)

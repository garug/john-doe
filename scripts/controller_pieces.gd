extends Node2D
## Control pieces and your attributes/properties

class_name ControllerPieces

@export var pieces: Array[GameCharacter] = []

signal active_changes(new_value, old_value)
signal piece_created(piece: GameCharacter)
signal piece_removed(piece: GameCharacter)

var active_piece: GameCharacter:
	set(value):
		active_changes.emit(value, active_piece)
		active_piece = value
	get:
		return active_piece

func _ready():
	init()
	active_changes.connect(_on_active_changes)

func init():
	for piece in pieces:
		init_character(piece)

func init_character(character: GameCharacter):
	character.init()
	piece_created.emit(character)

func _on_active_changes(new: GameCharacter, old: GameCharacter):
	if (old == null && new != null):
		disableCollisionForSameTeam(new)
	else:
		enableAllCollision()

func get_from_same_team(character: GameCharacter):
	return pieces.filter(func(p): return p.participant.id == character.participant.id)

func get_from_same_team_by_number(team: int):
	return pieces.filter(func(p): return p.participant.id == team)

func disableCollisionForSameTeam(character: GameCharacter):
	var characters_in_same_team = pieces.filter(func(p): return p.participant.id == character.participant.id and p != character)
	for c in characters_in_same_team:
		c.toggle_collision()

func enableAllCollision():
	var disabled_collision = pieces.filter(func(c): return c.colliding == false)
	for c in disabled_collision:
		c.toggle_collision()

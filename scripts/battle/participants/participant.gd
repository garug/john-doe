extends Node

class_name Participant

@export var id: int
@export var enemy: Participant

var controller_movement: ControllerMovement
var controller_pieces: ControllerPieces
var controller_turn: ControllerTurn
var controller_tiles: ControllerTiles

func init(movement: ControllerMovement, pieces: ControllerPieces, turn: ControllerTurn, tiles: ControllerTiles):
	controller_movement = movement
	controller_pieces = pieces
	controller_turn = turn
	controller_tiles = tiles
	controller_pieces.piece_created.connect(_on_piece_created)
	controller_movement.movement_ended.connect(_on_movement_ended)

func _on_piece_created(character: GameCharacter):
	if character.participant.id == id:
		character.touched.connect(_on_character_touched)

func _on_character_touched(character: GameCharacter):
	if controller_turn.turn_participant.id == character.participant.id:
		controller_pieces.active_piece = character
		
func _on_movement_ended(character: GameCharacter):
	if character.participant.id != id:
		return
	for attacker in controller_pieces.get_from_same_team(character):
		var targets = get_targets(attacker)
		for target in targets:
			attacker.do_attack(target)
	controller_turn.turn_end()

func get_targets(character: GameCharacter):
	return Callable(Targets, character.attack_type).call(character, controller_tiles)

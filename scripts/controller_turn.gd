extends Node2D
## Control turn flow

class_name ControllerTurn

@export var controller_movement: ControllerMovement
@export var controller_characters: ControllerPieces
@export var controller_tiles: ControllerTiles
@export var participants: Array[Participant] = []

var turn_participant: Participant

var turn := 0

signal turn_started(turn: int, team: int)

func _ready():
	_init_participants()
	turn_start(participants[0])
	
func _init_participants():
	for participant in participants:
		participant.init(controller_movement, controller_characters, self, controller_tiles)
	
func turn_start(participant: Participant):
	turn += 1
	turn_participant = participant
	print("turn started ", turn, participant)
	turn_started.emit(turn, participant)

func turn_end():
	turn_start(turn_participant.enemy)

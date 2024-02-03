extends Node2D

class_name GameTile

signal touched(tile, character)

var metadata = {}

func _on_area_2d_area_entered(area: Area2D):
	var character: GameCharacter = area.get_parent()

	touched.emit(self, character)

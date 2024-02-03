extends Node

class_name Directions

static var UP := Vector2i(0, -1)
static var DOWN := Vector2i(0, 1)
static var LEFT := Vector2i(-1, 0)
static var RIGHT := Vector2i(1, 0)
static var UP_RIGHT := Vector2i(-1, -1)
static var UP_LEFT := Vector2i(1, 1)
static var DOWN_RIGHT := Vector2i(1, -1)
static var DOWN_LEFT := Vector2i(-1, 1)

static func all():
	return [UP, DOWN, LEFT, RIGHT, UP_RIGHT, UP_LEFT, DOWN_RIGHT, DOWN_LEFT]

static func cardial():
	return [UP, RIGHT, DOWN, LEFT]

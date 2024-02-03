extends CharacterBody2D

class_name GameCharacter

static var DEFAULT_SIZE := Vector2.ONE * 64
static var DEFAULT_RECTANGLE_SHAPE := RectangleShape2D.new()
static var DEFAULT_COLLISION_SHAPE := CircleShape2D.new()
static var DEFAULT_SWAP_SHAPE := CircleShape2D.new()

@export_category("Properties")
@export var texture: Texture
@export var initial_position := Vector2.ZERO
@export var participant: Participant
var sprite: Sprite2D
var colliding := true
var initialized := false

@export_category("Attack")
@export var attack := 100
@export var defense := 100
@export var moves := 3
var life: float
@export_enum("distance", "magic", "meele") var attack_type = "meele"
@export_enum("all", "cardial") var attack_directions = "cardial"

var _collision: CollisionShape2D
var _swap_area: CollisionShape2D

signal touched(character: GameCharacter)

static func _static_init():
	DEFAULT_RECTANGLE_SHAPE.size = DEFAULT_SIZE
	DEFAULT_COLLISION_SHAPE.radius = 1
	DEFAULT_SWAP_SHAPE.radius = 16

func init():
	if initialized:
		print("tried to call init on a already initialized character")
		return
	_instantiate_sprite()
	_instantiate_collision_body()
	_instantiate_clickable_area()
	_instantiate_swap_area()
	_init_properties()
	global_position = global_position + DEFAULT_SIZE + initial_position * DEFAULT_SIZE
	initialized = true

func _init_properties():
	input_pickable = true
	input_event.connect(_on_input_event)
	set_collision_mask_value(1, false)
	set_collision_mask_value(2, true)
	life = defense
	
func _instantiate_sprite():
	sprite = Sprite2D.new()
	sprite.texture = texture
	add_child(sprite)

func _instantiate_clickable_area():
	var collision := CollisionShape2D.new()
	collision.shape = DEFAULT_RECTANGLE_SHAPE
	add_child(collision)

func _instantiate_swap_area():
	var area := Area2D.new()
	var collision := CollisionShape2D.new()
	collision.shape = DEFAULT_SWAP_SHAPE
	collision.debug_color = Color(0.69, 0.32, 0.93, 0.4)
	area.set_collision_layer_value(1, false)
	area.set_collision_mask_value(1, false)
	area.set_collision_layer_value(4, true)
	area.add_child(collision)
	add_child(area)
	_swap_area = collision
	
func _instantiate_collision_body():
	var body = StaticBody2D.new()
	var collision := CollisionShape2D.new()
	collision.shape = DEFAULT_COLLISION_SHAPE
	body.add_collision_exception_with(self)
	body.set_collision_layer_value(1, false)
	body.set_collision_mask_value(1, false)
	body.set_collision_layer_value(2, true)
	body.add_child(collision)
	add_child(body)
	_collision = collision
	
func actual_position():
	return snapped(position, DEFAULT_SIZE)

func do_attack(target: GameCharacter):
	target.life -= self.attack - target.defense

func move_and_snap(to: Vector2):
	move_and_collide(to - position)
	var final_pos = actual_position() - position
	move_and_collide(final_pos.round())

func move_slide(to: Vector2):
	velocity = (to - position) * 20
	move_and_slide()

func toggle_collision():
	colliding = !colliding
	_collision.disabled = !colliding

func toggle_swap():
	_swap_area.disabled = !_swap_area.disabled

func tween_position(to: Vector2):
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.tween_property(self, "global_position", to, .085)
	return tween

func _on_input_event(_viewport, event, _shape_idx):
	if (event.is_action_pressed("ui_interact")):
		touched.emit(self)

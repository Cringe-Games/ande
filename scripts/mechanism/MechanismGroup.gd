extends Node2D

const OPEN_ANIMATION_DURATION = 0.15

onready var door: StaticBody2D = $Door
onready var handler: Area2D = $Handler
onready var door_tween: Tween = $DoorTween

onready var door_rect: ColorRect = $Door/ColorRect
onready var door_rect_height: float = door_rect.rect_size.y
onready var door_position_open: Vector2 = door.position - Vector2(0, door_rect.rect_size.y);
onready var door_position_closed: Vector2 = door.position;

var currently_stepping: Array = []

func _ready():
	handler.connect("body_entered", self, "_on_Handler_body_entered")
	handler.connect("body_exited", self, "_on_Handler_body_exited")
	
func is_open():
	return door.position == door_position_open
	
func is_someone_standing():
	return currently_stepping.size() > 0

func _on_Handler_body_entered(body):
	if body is Player:
		# Add a new body to a list of bodies that are currently stepping on a button
		currently_stepping.append(body)
		
		# Open the door while someone is stending on a handler and it's not already open (DUH)
		if is_someone_standing() and not is_open():
			# Open up the door smoothly
			_move(door.position, door_position_open)

func _on_Handler_body_exited(body):
	if body is Player:
		# Remove the leaving body from the list
		currently_stepping.remove(currently_stepping.find(body))

		# Close the door whenever there's no one standing on a door
		if not is_someone_standing():
			# Close down the door smoothly
			_move(door.position, door_position_closed)

func _move(from: Vector2, to: Vector2):
	door_tween.interpolate_property($Door, "position", from, to, OPEN_ANIMATION_DURATION)
	door_tween.start()

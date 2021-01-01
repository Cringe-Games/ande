extends Node2D

const OPEN_ANIMATION_DURATION = 0.15

onready var door: StaticBody2D = $Door
onready var handler: Area2D = $Handler
onready var door_tween: Tween = $DoorTween

onready var door_rect: ColorRect = $Door/ColorRect
onready var door_rect_height: float = door_rect.rect_size.y

var is_open: bool = false
var in_progress: bool = false
var currently_stepping: Array = []

func _ready():
	$"../Debug".add_field("Players on a button: ", "_mg_p_")

	handler.connect("body_entered", self, "_on_Handler_body_entered")
	handler.connect("body_exited", self, "_on_Handler_body_exited")
	door_tween.connect("tween_all_completed", self, "_on_DoorTween_all_completed")
	
func _process(_delta):
	$"../Debug".update_field("_mg_p_", currently_stepping.size())
	is_open = currently_stepping.size() > 0
	
	
func _on_DoorTween_all_completed():
	in_progress = false
	
func _on_Handler_body_entered(body):
	# Add a new body to a list of bodies that are currently stepping on a button
	if body is Player:
		currently_stepping.append(body)

	if body is Player and currently_stepping.size() > 0 and not is_open and not in_progress:
		in_progress = true
		
		# Detect all necessary positions
		var current_position: Vector2 = door.position
		var end_position: Vector2 = door.position - Vector2(0, door_rect_height)
		
		# Open up the door smoothly
		door_tween.interpolate_property(door, "position", current_position, end_position, OPEN_ANIMATION_DURATION)
		door_tween.start()
		
func _on_Handler_body_exited(body):
	if body is Player:
		# Remove the leaving body from the list
		var body_index = currently_stepping.find(body)
		if body_index != -1:
			currently_stepping.remove(body_index)

	if body is Player and currently_stepping.size() == 0 and not in_progress:
		in_progress = true
		
		# Calculate all necessary positions
		var current_position: Vector2 = door.position
		var end_position: Vector2 = door.position + Vector2(0, door_rect_height)
		
		# Close down the door smoothly
		door_tween.interpolate_property($Door, "position", current_position, end_position, OPEN_ANIMATION_DURATION)
		door_tween.start()

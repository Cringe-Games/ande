extends Node2D

signal movement_completed

export var CAMERA_MOVEMENT_DURATION = 0.35

var in_progress: bool = false

# Camera
var camera: Camera2D = null
var camera_zoom: Vector2
var camera_position: Vector2

# Camera limits
var camera_limit_top: float
var camera_limit_bottom: float
var camera_limit_left: float
var camera_limit_right: float

func _ready():
	$CameraMotionTween.connect("tween_all_completed", self, "_on_tween_all_completed")
	$CameraMotionTween.connect("tween_step", self, "_on_tween_step")
	
	$"../Debug".add_field("CameraSwitch position", "_c_switch_pos")
	$"../Debug".add_field("CameraSwitch target position", "_c_switch_target_pos")
	$"../Debug".add_field("CameraSwitch inProgress", "_c_switch_in_prg")
	$"../Debug".add_field("CameraSwitch stepping", "_c_switch_stepping")
	
func _process(_delta):
	$"../Debug".update_field("_c_switch_in_prg", in_progress)
	if camera:
		$"../Debug".update_field("_c_switch_pos", camera.get_camera_position())

func _on_tween_step(_obj, _key, _elapsed, value):
	$"../Debug".update_field("_c_switch_stepping", value)

func _on_tween_all_completed():
	print("CameraSwitcher: emmitting `movement_completed` signal")
	emit_signal("movement_completed")
	in_progress = false
	camera.queue_free()

func move_camera(from_camera: Camera2D, to_camera: Camera2D):
	if in_progress:
		return false

	in_progress = true

	var to = to_camera.get_camera_position()
	var from = from_camera.get_camera_position()

	# Calculate relative movement speed, based on distance
	var distance = from.distance_to(to)
	var movement_velocity = CAMERA_MOVEMENT_DURATION - CAMERA_MOVEMENT_DURATION / distance

	print("CameraSwitcher: moving camera ", from, to, movement_velocity)

	# Create a new camera instance
	camera = _spawn_camera_instance()
	# Set the position for new camera
	camera.position = from
	# Set the camera on the parent object
	add_child(camera)
	# Make the camera current
	camera.current = true

	# Start a tween
	$CameraMotionTween.interpolate_property(camera, "position", from, to, movement_velocity, Tween.TRANS_LINEAR)
	$CameraMotionTween.start()

func setup_camera_config_from(origin: Camera2D):
	# Inherit zoom property by duplicating origin camera zoom vector
	camera_zoom = Vector2(origin.zoom)

	# Inherit origin camera limits
	camera_limit_top = origin.limit_top
	camera_limit_left = origin.limit_left
	camera_limit_right = origin.limit_right
	camera_limit_bottom = origin.limit_bottom

func _spawn_camera_instance():
	var camera = Camera2D.new()

	camera.zoom = camera_zoom

	camera.limit_top = camera_limit_top
	camera.limit_left = camera_limit_left
	camera.limit_right = camera_limit_right
	camera.limit_bottom = camera_limit_bottom
	
	return camera

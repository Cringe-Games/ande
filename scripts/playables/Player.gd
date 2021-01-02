extends KinematicBody2D

class_name Player

# Constants
const WALK_SPEED = 180
const JUMP_FORCE = 230
const JUMP_WALK_MODIFIER = 0.6
const GRAVITY = 450.0

onready var camera: Camera2D = $Camera2D

var ANIMATIONS = {
	"IDLE": "idle",
	"WALK": "walk",
	"JUMP": "jump"
}

# Variables
var velocity = Vector2()
var is_active: bool = true

var debug_key: String = "Player"
var debug_alias_prefix: String = "_p_"

var DEBUG_CAMERA_POS = debug_alias_prefix + "c_pos"
var DEBUG_PLAYER_POS = debug_alias_prefix + "p_pos"

const DEFAULT_MODULATE_COLOR: Color = Color(1, 1, 1, 1)
const INACTIVE_MODULATE_COLOR: Color = Color(0.1, 0.1, 0.1, 1)

func _ready():
	$"../Debug".add_field(debug_key + " camera pos", DEBUG_CAMERA_POS)
	$"../Debug".add_field(debug_key + " player pos", DEBUG_PLAYER_POS)

	$Animation.connect("animation_finished", self, "_on_Animation_animation_finished")
	# Init by playing the idle animation
	$Animation.play(ANIMATIONS.IDLE)
	
	# Make sure modulate reflects initial is_active state
	_update_modulate()
	
func _on_Animation_animation_finished():
	# If mid-air, stop any animations after jump is complete
	if $Animation.animation == ANIMATIONS.JUMP and not is_on_floor():
		$Animation.stop()

func can_handle_input():
	return is_active

func update_active_state(new_value: bool):
	is_active = new_value

	# Update current player modulate to visually notify the activity change
	_update_modulate()

func _update_modulate():
	modulate = DEFAULT_MODULATE_COLOR if is_active else INACTIVE_MODULATE_COLOR

func handle_input():
	if can_handle_input() and Input.is_action_pressed("left"):
		# Update speed
		velocity.x = -(WALK_SPEED if is_on_floor() else WALK_SPEED * JUMP_WALK_MODIFIER)

		# Update animations
		$Animation.flip_h = true
		if is_on_floor():
			$Animation.play(ANIMATIONS.WALK)

	elif can_handle_input() and Input.is_action_pressed("right"):
		# Update speed
		velocity.x = WALK_SPEED if is_on_floor() else WALK_SPEED * JUMP_WALK_MODIFIER

		# Update animations
		$Animation.flip_h = false
		if is_on_floor():
			$Animation.play(ANIMATIONS.WALK)

	else:
		velocity.x = 0
		if is_on_floor():
			$Animation.play(ANIMATIONS.IDLE)

	if can_handle_input() and Input.is_action_pressed("up") and is_on_floor():
		velocity.y = -JUMP_FORCE
		$Animation.play(ANIMATIONS.JUMP)

func _process(_delta):
	$"../Debug".update_field(DEBUG_CAMERA_POS, camera.get_camera_position())
	$"../Debug".update_field(DEBUG_PLAYER_POS, self.position)

func _physics_process(delta):
	# Apply gravity while not on the floor
	if is_on_floor() and velocity.y != 0:
		velocity.y = 0
	elif not is_on_floor():
		velocity.y += GRAVITY * delta

	var motion = velocity * delta;
	move_and_collide(motion)

	handle_input()

	# Initiate fall when touching the ceiling
	if is_on_ceiling():
		velocity.y = 0

	move_and_slide(velocity, Vector2.UP)

	# Manually forcing update
	# $Camera2D.force_update_scroll()

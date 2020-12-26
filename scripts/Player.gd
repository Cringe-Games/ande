extends KinematicBody2D

# Constants
const speed = 200
const gravity = 1000
const jumpForce = 600
const jumpThreshold = 0.4;

# Variables
var velocity = Vector2()

# States
var isFalling = false
var inAir = false

onready var sprite = get_node("Run")

func _ready():
	$AnimationPlayer.play("Idle")
	
func _process(delta):
	# Handle states transition
	if velocity.y > jumpThreshold and !isFalling:
		isFalling = true
		$AnimationPlayer.play("Fall")
	elif velocity.y < -jumpThreshold:
		inAir = true
		$AnimationPlayer.play("Jump")
	elif velocity.y == 0 and isFalling:
		inAir = false
		isFalling = false
		$AnimationPlayer.play("Idle")

func _physics_process(delta):
	# Handle animation transition
	
	# Moving left
	if Input.is_action_pressed("player_left"):
		velocity.x = -speed

		# Can't move left while mid air
		if !inAir:
			$AnimationPlayer.play("Run")
			

	# Stopped moving left
	elif Input.is_action_just_released("player_left"):
		# Bump the velocity to 0
		velocity.x = 0
		$AnimationPlayer.play("Idle")

	# Moving right
	elif Input.is_action_pressed("player_right"):
		velocity.x = speed
		if !inAir:
			$AnimationPlayer.play("Run")

	# Stopped moving right
	elif Input.is_action_just_released("player_right"):
		velocity.x = 0
		$AnimationPlayer.play("Idle")

	# Jumping, while on the floor
	if Input.is_action_pressed("player_jump") and is_on_floor():
		velocity.y = -jumpForce

	# Always apply gravity to the player Y coordinate
	velocity.y += gravity * delta
	# Perform move_and_slide to invoke "is_on_floor" method
	velocity = move_and_slide(velocity, Vector2.UP)
	
	# Perform sprite/image flipping based on X axis velocity
	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false

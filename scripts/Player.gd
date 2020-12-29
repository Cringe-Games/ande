extends KinematicBody2D

# Constants
const WALK_SPEED = 250
const GRAVITY = 1000.0

var ANIMATIONS = {
	"IDLE": "idle",
	"WALK": "walk"
}

# Variables
var velocity = Vector2()

func _ready():
	# Init by playing the idle animation
	$Animation.play(ANIMATIONS.IDLE)

func _physics_process(delta):
	# Apply gravity while not on the floor
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	var motion = velocity * delta;
	move_and_collide(motion)
	
	if Input.is_action_pressed("left"):
		# Update speed
		velocity.x = -WALK_SPEED
		
		# Update animations
		$Animation.flip_h = true
		$Animation.play(ANIMATIONS.WALK)

	elif Input.is_action_pressed("right"):
		# Update speed
		velocity.x = WALK_SPEED
		
		# Update animations
		$Animation.flip_h = false
		$Animation.play(ANIMATIONS.WALK)

	else:
		$Animation.play(ANIMATIONS.IDLE)
		velocity.x = 0
		
	move_and_slide(velocity, Vector2.UP)

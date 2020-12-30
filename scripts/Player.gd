extends KinematicBody2D

# Constants
const WALK_SPEED = 230
const JUMP_FORCE = 300
const JUMP_WALK_MODIFIER = 0.65
const GRAVITY = 1000.0

var ANIMATIONS = {
	"IDLE": "idle",
	"WALK": "walk",
	"JUMP": "jump"
}

# Variables
var velocity = Vector2()

func _ready():
	$Animation.connect("animation_finished", self, "on_Animation_animation_finished")
	# Init by playing the idle animation
	$Animation.play(ANIMATIONS.IDLE)
	
func _on_Animation_animation_finished():
	# If mid-air, stop any animations after jump is complete
	if $Animation.animation == ANIMATIONS.JUMP and not is_on_floor():
		$Animation.stop()

func _physics_process(delta):
	# Apply gravity while not on the floor
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	var motion = velocity * delta;
	move_and_collide(motion)
	
	if Input.is_action_pressed("left"):
		# Update speed
		velocity.x = -(WALK_SPEED if is_on_floor() else WALK_SPEED * JUMP_WALK_MODIFIER)
		
		# Update animations
		$Animation.flip_h = true
		if is_on_floor():
			$Animation.play(ANIMATIONS.WALK)

	elif Input.is_action_pressed("right"):
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
		
	if Input.is_action_pressed("up") and is_on_floor():
		velocity.y = -JUMP_FORCE
		$Animation.play(ANIMATIONS.JUMP)
		
	move_and_slide(velocity, Vector2.UP)

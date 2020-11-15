extends KinematicBody2D

var speed = 200
var jumpForce = 600
var gravity = 1000
var vel  = Vector2()
var isFalling = false
var inAir = false

onready var playerImage = get_node("Run")

func _ready():
	$AnimationPlayer.play("Idle")	
	
func _process(delta):
	
	if vel.y > 0.4 and !isFalling:
		print(vel.y)
		$AnimationPlayer.play("Fall")
		inAir = true
		isFalling = true
	elif vel.y < -0.4:
		print(vel.y)
		inAir = true
		$AnimationPlayer.play("Jump")
	elif vel.y == 0 and isFalling:
		$AnimationPlayer.play("Idle")
		isFalling = false
		inAir = false
	
	
	
func _physics_process(delta):
	if Input.is_action_pressed("player_left"):
		vel.x  = -speed
		if !inAir:
			$AnimationPlayer.play("Run")	
	elif Input.is_action_just_released("player_left"):
		vel.x = 0
		$AnimationPlayer.play("Idle")	
	elif Input.is_action_pressed("player_right"):
		vel.x = speed
		if !inAir:
			$AnimationPlayer.play("Run")	
	elif Input.is_action_just_released("player_right"):
		vel.x = 0	
		$AnimationPlayer.play("Idle")	
		
	vel.y += gravity * delta	
		
	if Input.is_action_pressed("player_jump") and is_on_floor():
		vel.y = -jumpForce
		
	vel = move_and_slide(vel, Vector2.UP)
	
	if vel.x < 0:
		playerImage.flip_h = true
	elif vel.x > 0:
		playerImage.flip_h = false
		
		

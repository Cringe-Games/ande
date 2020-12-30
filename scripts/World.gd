extends Node2D

const PlayableFactory : PackedScene = preload("res://Player.tscn")
onready var link_manager : LinkManager = LinkManager.new()

func _ready():
	var main_player = PlayableFactory.instance()
	# Update main player position
	main_player.position = $SpawnLocation.position
	# Add main player to the scene
	add_child(main_player)
	# Link main character to make him active
	link_manager.link_new_playable(main_player)

var switch = true
func _process(_delta):
	# On button press switch between
	# Adding a new playable into a list,
	# or removing the last one
	if Input.is_action_just_pressed("ui_accept"):
		link_manager.link_new_playable($Warrior) if switch else link_manager.unlink_last_playable()
		switch = not switch

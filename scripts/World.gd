extends Node2D

const PlayerFactory : PackedScene = preload("res://Player.tscn")
onready var link_manager : LinkManager = LinkManager.new()

func _ready():
	var main_player = PlayerFactory.instance()
	var warriors = get_tree().get_nodes_in_group("warriors")
	# Update main player position
	main_player.position = $SpawnLocation.position
	# Add main player to the scene
	add_child(main_player)

	# Populate link manager with the required data and let it do its magic!
	link_manager.set_main_player(main_player)
	link_manager.add_warriors(warriors)

func _physics_process(_delta):
	var space_state = get_world_2d().direct_space_state
	link_manager.get_available_links(space_state)
	
	# If currently playing as warrior,
	# Make sure to test the connection with main player
	# Note, LinkManager will handle connection loss action automatically
	if not link_manager.is_main_player_active():
		link_manager.check_connection(space_state)

func _process(_delta):
		if Input.is_action_just_pressed("ui_accept"):
			if not link_manager.is_main_player_active():
				link_manager.activate_main_player()
			elif link_manager.has_links():
				# For now, keep the value hardcoded to the first available warrior
				var available_warrior = link_manager.available_links[0]
				link_manager.activate_warrior(available_warrior)

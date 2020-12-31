extends Node2D

const PlayerFactory : PackedScene = preload("res://Player.tscn")
onready var link_manager : LinkManager = LinkManager.new()

func _ready():
	$Debug.add_field("Link: is main active", "_link_is_main_active")
	$Debug.add_field("Link: can link", "_link_can_link")
	
	# Establish all required signal connections
	link_manager.connect("on_connection_lost", self, "_on_link_connection_lost")
	$CameraSwitcher.connect("movement_completed", self, "_on_SwitchTween_all_completed")

	# Initialize any variables
	var main_player = PlayerFactory.instance()
	var warriors = get_tree().get_nodes_in_group("warriors")
	
	# Update main player position
	main_player.position = $SpawnLocation.position
	# Add main player to the scene
	add_child(main_player)

	# Populate link manager with the required data and let it do its magic!
	link_manager.set_main_player(main_player)
	link_manager.add_warriors(warriors)
	
	# Set up the SwitchCamera props by givin player camera as an example
	$CameraSwitcher.setup_camera_config_from(main_player.camera)

func _on_link_connection_lost(lost_warrior: Warrior):
	# This method should just start the tween
	print("Connection lost with...", lost_warrior.position)
	
	link_manager.activate_main_player()
	$CameraSwitcher.move_camera(lost_warrior.camera, link_manager.main_player.camera)
	
func _on_SwitchTween_all_completed():
	link_manager.currently_active.camera.current = true
	link_manager.enable_active()

func start_switch_camera_tween(from: Camera2D, to: Camera2D):
	# This methos should start a tween that moves SwitchCamera to a new position
	print("World: Starting a camera switch action...", from.get_camera_position(), to.get_camera_position())
	$CameraSwitcher.move_camera(from, to)

func _process(_delta):
	var space_state = get_world_2d().direct_space_state
	link_manager.get_available_links(space_state)
	
	# If currently playing as warrior,
	# Make sure to test the connection with main player
	$Debug.update_field("_link_is_main_active", link_manager.is_main_player_active())
	$Debug.update_field("_link_can_link", bool(link_manager.has_links()))

	if not link_manager.is_main_player_active() and not $CameraSwitcher.in_progress:
		link_manager.check_connection(space_state)

	# Links are available, draw the pointer line
	$LinkDrawer.toggle(link_manager.has_links())
	$LinkDrawer.draw_from_manager(link_manager)
	
	if Input.is_action_just_pressed("ui_accept"):
		# Don't allow switches while current camera movement is in progress
		if $CameraSwitcher.in_progress:
			return
		
		# Flag to keep track of the further execution
		var should_move_camera = false
		var old_target: Player = link_manager.currently_active
		
		if not link_manager.is_main_player_active():
			should_move_camera = true
			# Activate main
			link_manager.activate_main_player()

		# Manually switching to a new warrior
		elif link_manager.has_links():
			should_move_camera = true
			# For now, keep the value hardcoded to the first available warrior
			var available_warrior = link_manager.available_links[0]
			# Then activate warrior
			link_manager.activate_warrior(available_warrior)

		if should_move_camera:
			link_manager.currently_active.is_active = false
			start_switch_camera_tween(old_target.camera, link_manager.currently_active.camera)

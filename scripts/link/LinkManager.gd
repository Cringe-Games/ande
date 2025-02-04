extends Resource

signal on_connection_lost

class_name LinkManager

var main_player: Player
var currently_active: Player

var warriors: Array = []
var available_links: Array = []

const LINK_DISTANCE_LIMIT = 200

func set_main_player(player: Player):
	self.main_player = player
	
	# Make the main player a currently active
	currently_active = player
	
func add_warriors(warriors: Array):
	self.warriors = warriors
	
func get_available_links(space_state: Physics2DDirectSpaceState):
	# Reset the list of links on every run
	available_links = []

	# Find all warriors that don't have intersections
	for warrior in warriors:
		var intersect_result: Dictionary = space_state.intersect_ray(main_player.position, warrior.position, [main_player, warrior])
		
		var has_obstacle = intersect_result.has("position")
		var within_range = main_player.position.distance_to(warrior.position) < LINK_DISTANCE_LIMIT
		
		if not has_obstacle and within_range:
			available_links.append(warrior)
	
	# Make the list available for caller
	return available_links
	
func has_links():
	return available_links.size()
	
func check_connection(space_state: Physics2DDirectSpaceState):
	# Always "true" for main_player
	if is_main_player_active():
		return true
	
	# Otherwise, cast a ray from currently active player to main character
	var intersect_result: Dictionary = space_state.intersect_ray(currently_active.position, main_player.position, [currently_active, main_player])
	var has_obstacle = intersect_result.has("position")
	var within_range = currently_active.position.distance_to(main_player.position) < LINK_DISTANCE_LIMIT
	
	# Notify any interested parties about connection loss
	if has_obstacle or not within_range:
		emit_signal("on_connection_lost", currently_active)
	
func is_main_player_active():
	return currently_active == main_player

func _switch(player_object: Player, on_off: bool):
	player_object.update_active_state(on_off)
	
	player_object.camera.current = on_off

func activate_warrior(warrior: Warrior):
	# Deactivate currently active player and its camera
	_switch(currently_active, false)
	
	# Activate provided warrior
	_switch(warrior, true)
	
	# Set the warrior as currently active
	currently_active = warrior
	
func activate_main_player():
	# Deactivate currently active if it's not a main player
	_switch(currently_active, false)
	
	# Switch main player back on
	_switch(main_player, true)
	
	# Update a currently active reference
	currently_active = main_player

func disable_active():
	currently_active.update_active_state(false)
	currently_active.camera.current = false

func enable_active():
	currently_active.update_active_state(true)
	currently_active.camera.current = true

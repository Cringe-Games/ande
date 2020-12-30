extends Node

class_name LinkManager

var Players : Array = []
var current_player : Playable = null

func _activate_player_and_camera():
	var current_player_camera : Camera2D = current_player.camera
	
	if current_player and current_player_camera:
		current_player.is_active = true
		current_player_camera.current = true
	
func link_new_playable(playable: Playable):
	Players.append(playable)
	
	# Make current player inactive
	if current_player:
		current_player.is_active = false
	
	# Assign new current_player to be the last item in the array
	current_player = Players[Players.size() - 1]
	_activate_player_and_camera()

func unlink_last_playable():
	# If current player exists
	if (current_player):
		# Deactivate current_player
		current_player.is_active = false
	
	# While more then one player is in the list
	if (Players.size() > 1):
		# Make sure to remove the last player from the list
		Players.pop_back()
	
	# Reassign current player to a new playable object
	current_player = Players[Players.size() - 1]
	_activate_player_and_camera()

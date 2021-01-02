extends Player

class_name Warrior

func _init():
	# By default Warriors supposed to be inactive
	is_active = false
	
	# Override playable related debug keys
	debug_key = "Warrior"
	debug_alias_prefix = "_w_"
	DEBUG_CAMERA_POS = debug_alias_prefix + "c_pos"
	DEBUG_PLAYER_POS = debug_alias_prefix + "p_pos"

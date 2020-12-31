extends Player

class_name Warrior

func _init():
	is_active = false
	debug_key = "Warrior"
	debug_alias_prefix = "_w_"
	DEBUG_CAMERA_POS = debug_alias_prefix + "c_pos"
	DEBUG_PLAYER_POS = debug_alias_prefix + "p_pos"

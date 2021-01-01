extends Node2D

var should_draw: bool = true
onready var line: Line2D = $Line2D

func _ready():
	# Set up debugger
	$"../Debug".add_field("Drawing point: ", "_link_d_d")

	# Dynamically insert line in the tree
	add_child(line)
	
func toggle(new_flag_value: bool):
	if new_flag_value:
		_toggle_on()
	else:
		_toggle_off()

func _toggle_on():
	should_draw = true

func _toggle_off():
	should_draw = false

func draw_from_manager(manager: LinkManager):
	# Always clean any existing points
	if line.points.size():
		line.clear_points()
		
	var to   : Vector2
	var from : Vector2 = manager.currently_active.position
		
	if not should_draw:
		return

	elif not manager.is_main_player_active():
		to = manager.main_player.position

	# Manually switching to a new warrior
	elif manager.has_links():
		# For now, keep the value hardcoded to the first available warrior
		var available_warrior = manager.available_links[0]
		to = available_warrior.position

	line.add_point(from)
	line.add_point(to)

	$"../Debug".update_field("_link_d_d", str(from) + " : " + str(to))

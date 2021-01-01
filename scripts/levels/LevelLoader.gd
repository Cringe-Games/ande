extends Node

const LEVELS_DIR_PREFIX = "res://scenes/levels/"
const end_screen: PackedScene = preload("res://scenes/end_screen.tscn")

var _levels: Array = []
var _current_level_index: int = 0

func _get_all_scene_files():
	# Get all .tscn files from res://scenes/levels/
	var directory = Directory.new()
	
	# Open a folder containing all of the level scenes
	directory.open(LEVELS_DIR_PREFIX)
	# Start looping through all the files, excluding navigational "." and ".."
	directory.list_dir_begin(true)
	
	while true:
		var file_name = directory.get_next()
		# Probably reached the end of the directory
		if file_name == "":
			break
		# File looks like a level scene, so add it to the list of all levels
		if file_name.begins_with("Level") and file_name.ends_with(".tscn"):
			_levels.append(LEVELS_DIR_PREFIX + file_name)
			
	# Stopped looping trough files, probably closing the stream or whatever
	directory.list_dir_end()

func load_all_levels():
	# Somehow fetch all scenes from in the scenes/levels
	_get_all_scene_files()

func get_scene_count():
	return _levels.size()
	
func load_next():
	# We've reached the last level scene
	if (_current_level_index == get_scene_count()):
		# Load the end screen now
		get_tree().change_scene_to(end_screen)
	
	# Otherwise, loading the next available level
	var next_level = _levels[_current_level_index]
	
	# Increment the scene index
	_current_level_index += 1
	
	# Load and replace current scene with the next one
	get_tree().change_scene(next_level)

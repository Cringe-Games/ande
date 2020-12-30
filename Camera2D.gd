extends Camera2D

onready var viewbox_size = get_viewport_rect().size

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set Player camera limits
	self.limit_top = 0
	self.limit_left = 0
	self.limit_right = viewbox_size.x
	self.limit_bottom = viewbox_size.y

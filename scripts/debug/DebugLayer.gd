extends CanvasLayer

var fields: Dictionary = {}

const ENABLED: bool = false

func _ready():
	$Control/Background.rect_size = Vector2($Control.rect_size.x, 0)

func add_field(key, alias: String = ""):
	if not ENABLED:
		return

	var field_key_label = Label.new()
	var field_value_label = Label.new()
	var field_wrapper = HBoxContainer.new()
	
	field_key_label.text = key + ": "
	field_value_label.text = "None"
	
	fields[key if alias == "" else alias] = field_value_label
	
	field_wrapper.add_child(field_key_label)
	field_wrapper.add_child(field_value_label)
	$Control/Layout.add_child(field_wrapper)
	
	# Recalculate 
	$Control/Background.rect_size.y += 50
	
func update_field(key, value):
	if (ENABLED and fields.has(key)):
		fields[key].text = str(value)

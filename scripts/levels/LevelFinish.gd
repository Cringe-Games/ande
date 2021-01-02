extends Area2D

func _ready():
	self.connect("body_entered", self, "_on_LevelFinish_body_entered")

func _on_LevelFinish_body_entered(body):
	# Prevent warriors from finishing the game
	if body is Player and not body is Warrior:
		LevelLoader.load_next()

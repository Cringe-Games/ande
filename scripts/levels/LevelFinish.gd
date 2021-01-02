extends Area2D

func _ready():
	self.connect("body_entered", self, "_on_LevelFinish_body_entered")

func _on_LevelFinish_body_entered(body):
	LevelLoader.load_next()

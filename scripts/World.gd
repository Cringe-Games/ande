extends Node2D


const PlayerScene : PackedScene = preload("res://Player.tscn")
var Player : KinematicBody2D = null

func _ready():
	# Dynamically spawn new player (KinematicBody2D) instance
	Player = PlayerScene.instance()
	Player.position = $SpawnLocation.position
	add_child(Player)

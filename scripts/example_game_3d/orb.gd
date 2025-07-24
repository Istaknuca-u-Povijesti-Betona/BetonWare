extends Node3D

var game : Node

func hit():
	game.add_score()
	self.queue_free()

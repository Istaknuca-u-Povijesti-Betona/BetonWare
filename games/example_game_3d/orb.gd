extends Node3D

var main : Node

func hit():
	main.add_score()
	self.queue_free()

extends Node3D

var root_node
var game_description: String = "ENTER THE THIRD DIMENSION!"	# Short guide for the game that flashes before it starts
var game_author: String = "My Name"							# Your name for game credit
var game_time_seconds: int = 15								# Time in seconds until automatic loss, set to 0 for unlimited

func _ready():
	root_node = self.get_parent()

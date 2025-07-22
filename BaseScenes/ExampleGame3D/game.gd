extends Node3D

var RootNode
var GameDescription: String = "ENTER THE THIRD DIMENSION!"	# Short guide for the game that flashes before it starts
var GameAuthor: String = "My Name"							# Your name for game credit
var GameTimeSeconds: int = 15								# Time in seconds until automatic loss, set to 0 for unlimited

func _ready():
	RootNode = self.get_parent()

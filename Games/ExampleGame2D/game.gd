extends ColorRect

var RootNode
var GameDescription: String = "PRESS THE WIN BUTTON!"	# Short guide for the game that flashes before it starts
var GameAuthor: String = "My Name"						# Your name for game credit
var GameTimeSeconds: int = 15							# Time in seconds until automatic loss, set to 0 for unlimited

func _ready():
	RootNode = self.get_parent()

# EVERYTHING ABOVE IS REQUIRED FOR SHIT TO WORK

func _on_button_win_pressed():
	RootNode.game_end("Win")	# End the game with this function, pass either "Win" or "Loss" as the parameter

func _on_button_loss_pressed():
	RootNode.game_end("Loss")

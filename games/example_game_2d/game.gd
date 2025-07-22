extends ColorRect

var root_node
var game_description: String = "PRESS THE WIN BUTTON!"	# Short guide for the game that flashes before it starts
var game_author: String = "My Name"						# Your name for game credit
var game_time_seconds: int = 15							# Time in seconds until automatic loss, set to 0 for unlimited

func _ready():
	root_node = self.get_parent()

# EVERYTHING ABOVE IS REQUIRED FOR SHIT TO WORK

func _on_button_win_pressed():
	root_node.game_end("win")	# End the game with this function, pass either "Win" or "Loss" as the parameter

func _on_button_loss_pressed():
	root_node.game_end("loss")

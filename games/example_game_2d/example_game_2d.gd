extends MinigameBase # This line is required at the start of the script of your root node!
# Customise game info in the Inspector view of your root node (must be extending MinigameBase)
# It is advised you have your root node as a regular generic Node

func _ready():
	super._ready()			# You will need to call this function if you are utilising _ready()
	print("Woah, the game loaded")

func _on_button_win_pressed():
	minigame.end_game(WIN)	# End the game with this function, pass either WIN or LOSS as the parameter.

func _on_button_loss_pressed():
	minigame.end_game(LOSS)

extends MinigameBase # This line is required! Check your root node in the Inspector view to change game name.

func _on_button_win_pressed():
	root_node.end_game("win")	# End the game with this function, pass either "win" or "loss" as the parameter.

func _on_button_loss_pressed():
	root_node.end_game("loss")

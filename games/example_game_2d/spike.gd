extends Constants

var game : Node

func _on_body_entered(body):
	if body == game.player:
		game.minigame.end_game(LOSS)

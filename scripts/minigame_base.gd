class_name MinigameBase
extends Constants

var minigame : Node
@export var game_description : String = "GAME TITLE!"
@export var game_author : String = "Developer"
@export var game_time_seconds : int = 15

func _ready():
	minigame = self.get_parent()

class_name MinigameBase
extends Constants

var minigame : Node
@export var game_description : String = "UNTITLED GAME!"
@export var game_author : String = "Unknown"
@export var game_time_seconds : int = 15

func _ready():
	minigame = self.get_parent()

func _on_timer_ticked():
	pass

class_name MinigameBase
extends Node

var root_node : Node
@export var game_description : String = "GAME TITLE!"
@export var game_author : String = "Developer"
@export var game_time_seconds : int = 15

func _ready():
	root_node = self.get_parent()

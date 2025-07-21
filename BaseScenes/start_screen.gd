extends Node

var RootNode

func _ready():
	RootNode = self.get_parent()

func _on_start_button_pressed():
	RootNode.start_game()

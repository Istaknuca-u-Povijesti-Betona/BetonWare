extends Node

var root_node

func _ready():
	root_node = self.get_parent()

func _on_start_button_pressed():
	root_node.start_game()

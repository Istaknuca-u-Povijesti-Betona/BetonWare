extends Node

var root_node

func _ready():
	root_node = self.get_parent()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_start_button_pressed():
	root_node.start_game()

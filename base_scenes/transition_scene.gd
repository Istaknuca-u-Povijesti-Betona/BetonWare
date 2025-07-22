extends ColorRect

var game_label
var developer_label
var health_bar

var health_sprite = preload("res://resources/textures/heart.svg")
var health_broken_sprite = preload("res://resources/textures/heart_darker.svg")

func _ready():
	game_label = $LabelsContainer/GameLabel
	developer_label = $LabelsContainer/DevLabel
	health_bar = $HealthBarContainer/HealthBar

func set_labels(game_name, developer_name):
	game_label.set_text(str(game_name))
	developer_label.set_text("By: " + str(developer_name))

func clear_labels():
	game_label.set_text("")
	developer_label.set_text("")

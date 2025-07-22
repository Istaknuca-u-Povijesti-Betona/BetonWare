extends ColorRect

var GameLabel
var DeveloperLabel
var HealthBar

var HealthSprite = preload("res://Resources/Textures/Heart.svg")
var HealthBrokenSprite = preload("res://Resources/Textures/HeartDarker.svg")

func _ready():
	GameLabel = $LabelsContainer/GameLabel
	DeveloperLabel = $LabelsContainer/DevLabel
	HealthBar = $HealthBarContainer/HealthBar

func set_labels(GameName, DeveloperName):
	GameLabel.set_text(str(GameName))
	DeveloperLabel.set_text("By: " + str(DeveloperName))

func clear_labels():
	GameLabel.set_text("")
	DeveloperLabel.set_text("")

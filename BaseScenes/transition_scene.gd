extends ColorRect

var GameLabel
var DeveloperLabel
var HealthBar

var HealthBrokenSprite = preload("res://Resources/Textures/HeartDarker.svg")

func _ready():
	GameLabel = $LabelsContainer/GameLabel
	DeveloperLabel = $LabelsContainer/DeveloperLabelsContainer/DevLabel
	HealthBar = $HealthBarContainer/HealthBar

func set_labels(GameName, DeveloperName):
	GameLabel.set_text(str(GameName))
	DeveloperLabel.set_text(str(DeveloperName))

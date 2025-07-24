extends MinigameBase

var player : Node
var spikes : Node

func _ready():
	super._ready()
	RenderingServer.set_default_clear_color(Color(0.8392156862745098, 0.8392156862745098, 0.8392156862745098))
	player = $Character
	spikes = $Spikes
	for i in spikes.get_child_count():
		spikes.get_child(i).game = self

func _on_flag_body_entered(body):
	if body == player:
		minigame.end_game(WIN)

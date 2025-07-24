extends Constants

var timer_label : Node
var timer_time_left : int = 0

func _ready():
	timer_label = $TimerLabel

func _on_timeout():
	if timer_time_left > 0:
		timer_time_left -= 1
	else:
		timer_time_left = 0
		self.get_parent().end_game(LOSS)
		var myself : Node = self
		myself.stop()
	
	timer_label.set_text(str(timer_time_left))

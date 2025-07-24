extends Constants

var timer : Node
var timer_label : Node
var time_left : int = 0

func _ready():
	timer = $Timer
	timer_label = $TimerLabel

func _on_timer_tick():
	self.get_parent().get_child(0)._on_timer_ticked()
	if time_left > 1:
		time_left -= 1
	else:
		time_left = 0
		self.get_parent().end_game(LOSS)
		timer.stop()
	
	timer_label.set_text(str(time_left))

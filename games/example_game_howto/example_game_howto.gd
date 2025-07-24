# This line is required at the start of the script of your root node!
extends MinigameBase

# Customise game info in the Inspector view of your root node (must be extending MinigameBase)
# It is advised you have your root node as a regular generic Node

# PLEASE USE ANCHORS WHEN MAKING 2D GAMES / UI!

func _ready():
	# You will need to call super._ready() if you are utilising _ready()
	super._ready()
	
	print("Eeyikes! How am I supposed to \"Play\" this \"Game\" without any variables!?")

func _on_win_button_pressed():
	minigame.end_game(WIN)		# End the game with this function, pass either WIN or LOSS as the parameter.

func _on_loss_button_pressed():
	minigame.end_game(LOSS)

func _on_pause_timer_button_pressed():
	if minigame.timer_is_paused() == false:	# Check if the timer is currently paused
		minigame.pause_timer(true)			# Pause the timer
		$Background/PauseTimerButton.text = "click to pause the timer"
	else:
		minigame.pause_timer(false)
		$Background/PauseTimerButton.text = "click to unpause the timer"

func _on_add_time_button_pressed():
	minigame.add_time(5)					# Add time to the timer (int), this can also be a negative value

func _on_randomize_timer_color_button_pressed():
	var random_r = randf()
	var random_g = randf()
	var random_b = randf()
	var new_font_color = Color(random_r, random_g, random_b, 1.0)
	minigame.set_timer_color(new_font_color)

func _on_hide_timer_button_pressed():
	if minigame.timer_is_hidden() == false:	# Check if the timer is currently hidden
		minigame.hide_timer(false)			# Hide the timer
		$Background/HideTimerButton.text = "click to hide the timer"
	else:
		minigame.hide_timer(true)
		$Background/HideTimerButton.text = "click to unhide the timer"

func _on_special_button_pressed():
	if minigame.get_time() >= 20:			# Get current timer time (int)
		$Elitism.visible = true
		await get_tree().create_timer(2.5).timeout
		$Elitism.visible = false

func _on_timer_ticked():					# This function is called every time the timer ticks down
	if minigame.get_time() % 2 == 0:
		$Tick.visible = true
		$Tick.modulate.a = 1
		var tween : Tween = get_tree().create_tween()
		tween.tween_property($Tick, "modulate:a", 0, 1.0)
	else:
		$Tock.visible = true
		$Tock.modulate.a = 1
		var tween : Tween = get_tree().create_tween()
		tween.tween_property($Tock, "modulate:a", 0, 1.0)

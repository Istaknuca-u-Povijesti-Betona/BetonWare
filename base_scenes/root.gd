extends Node

var max_health : int = 3
var health : int = max_health
var window_size : Vector2
var scenes_directory : String = "res://games/"
var main_menu_scene : PackedScene = preload("res://base_scenes/start_screen.tscn")
var timer_scene : PackedScene = preload("res://base_scenes/timer.tscn")
var transition_scene : PackedScene = preload("res://base_scenes/transition_scene.tscn")
var pop_up_scene : PackedScene = preload("res://base_scenes/pop_up_animation_sprite.tscn")
var game_over_scene : PackedScene = preload("res://base_scenes/game_over.tscn")

var animation_speed : float = 0.5
var wiggle_speed : float = 0.10
var outcome_hold_duration : float = 0.75
var transition_hold_duration : float = 0.75
var transition_loss_hold_duration : float = 1.0

func transition_animation(target, direction):
	window_size = get_viewport().get_visible_rect().size
	var tween : Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	match direction:
		"in":
			target.position.y = window_size.y
			tween.tween_property(target, "position", Vector2.ZERO, animation_speed)
		"out":
			tween.tween_property(target, "position", Vector2(0, 0 - window_size.y), animation_speed)

func play_animation(type):
	self.add_child(pop_up_scene.instantiate())
	var pop_up_scene_node : Node = self.get_child(-1)
	match type:
		"win":
			pop_up_scene_node.sprite.set_texture(load("res://resources/textures/checkmark.svg"))
		"loss":
			pop_up_scene_node.sprite.set_texture(load("res://resources/textures/cross.svg"))
	
	transition_animation(pop_up_scene_node, "in")
	await get_tree().create_timer(outcome_hold_duration).timeout
	transition_animation(pop_up_scene_node, "out")
	await get_tree().create_timer(animation_speed).timeout
	
	pop_up_scene_node.queue_free()

func animation_wiggle(target, direction):
	var tween : Tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(target, "position", direction, wiggle_speed)

func load_game(scene_to_switch_to, type):
	self.add_child(transition_scene.instantiate())
	var transition : Node = self.get_child(-1)
	
	transition.set_labels(scene_to_switch_to.game_description, scene_to_switch_to.game_author)
	for i in max_health - health:
		transition.health_bar.get_child(i).set_texture(transition.health_broken_sprite)
	if health == 0:
		transition.clear_labels()
	
	if type == "loss":
		transition.health_bar.get_child(max_health - health - 1).set_texture(transition.health_sprite)
	
	transition_animation(transition, "in")
	await get_tree().create_timer(transition_hold_duration).timeout
	
	if type == "loss":
		for i in max_health - health:
			var current_heart : Node = transition.health_bar.get_child(i)
			current_heart.set_texture(transition.health_broken_sprite)
			var heart_position : Vector2 = transition.health_bar.get_child(i).position
			animation_wiggle(current_heart, Vector2(heart_position.x - 10, 0))
			await get_tree().create_timer(0.10).timeout
			animation_wiggle(current_heart, Vector2(heart_position.x + 10, 0))
			await get_tree().create_timer(0.10).timeout
			animation_wiggle(current_heart, Vector2(heart_position.x, 0))
		await get_tree().create_timer(0.50).timeout
		
		if health == 0:
			restart()
	
	self.get_child(0).queue_free()
	if self.get_child(1).get_name() == "Timer":
		self.get_child(1).queue_free()
	self.add_child(scene_to_switch_to)
	move_child(scene_to_switch_to, 0)
	
	var timer : Node = timer_scene.instantiate()
	self.add_child(timer)
	timer.timer_time_left = scene_to_switch_to.game_time_seconds
	timer.start()
	move_child(timer, 1)
	
	transition_animation(transition, "out")
	await get_tree().create_timer(animation_speed).timeout
	transition.queue_free()

func restart():
	self.add_child(game_over_scene.instantiate())
	var game_over_scene_instance : Node = self.get_child(-1)
	game_over_scene_instance.position.y = get_viewport().get_visible_rect().size.y
	
	transition_animation(game_over_scene_instance, "in")
	await get_tree().create_timer(transition_loss_hold_duration).timeout
	
	self.get_child(0).queue_free()
	self.add_child(main_menu_scene.instantiate())
	move_child(self.get_child(-1), 0)
	
	transition_animation(game_over_scene_instance, "out")
	await get_tree().create_timer(animation_speed).timeout
	game_over_scene_instance.queue_free()

func end_game(status):
	match status:
		"win":
			play_animation("win")
			await get_tree().create_timer(outcome_hold_duration).timeout
			load_random_game("win")
		"loss":
			health -= 1
			play_animation("loss")
			await get_tree().create_timer(outcome_hold_duration).timeout
			load_random_game("loss")
	if status != "win" and status != "loss":
		push_error("Invalid parameter recieved")
	await get_tree().create_timer(animation_speed).timeout
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func start_game():
	health = max_health
	load_random_game("win")

func load_random_game(type):
	var random_directory : String = Array(ResourceLoader.list_directory(scenes_directory)).pick_random()
	var random_game : PackedScene = load(scenes_directory + random_directory + "game.tscn")
	var loaded_game : Node = random_game.instantiate()
	load_game(loaded_game, type)

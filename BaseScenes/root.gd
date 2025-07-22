extends Node

var max_health : int = 3
var health : int = max_health
var window_size : Vector2
var scenes_directory : String = "res://Games/"
var main_menu_scene : PackedScene = preload("res://BaseScenes/StartScreen.tscn")
var transition_scene : PackedScene = preload("res://BaseScenes/TransitionScene.tscn")
var pop_up_scene : PackedScene = preload("res://BaseScenes/PopUpAnimationSprite.tscn")
var game_over_scene : PackedScene = preload("res://BaseScenes/game_over.tscn")

var animation_speed : float = 0.5
var wiggle_speed : float = 0.10
var outcome_hold_duration : float = 0.75
var transition_hold_duration : float = 0.75
var transition_loss_hold_duration : float = 1.0

func _ready():
	pass

func transition_animation(target, direction):
	window_size = get_viewport().get_visible_rect().size
	var tween : Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	match direction:
		"In":
			target.position.y = window_size.y
			tween.tween_property(target, "position", Vector2.ZERO, animation_speed)
		"Out":
			tween.tween_property(target, "position", Vector2(0, 0 - window_size.y), animation_speed)

func play_animation(type):
	self.add_child(pop_up_scene.instantiate())
	var pop_up_scene_node : Node = self.get_child(-1)
	match type:
		"Win":
			pop_up_scene_node.Sprite.set_texture(load("res://Resources/Textures/Checkmark.svg"))
		"Loss":
			pop_up_scene_node.Sprite.set_texture(load("res://Resources/Textures/Cross.svg"))
	
	transition_animation(pop_up_scene_node, "In")
	await get_tree().create_timer(outcome_hold_duration).timeout
	transition_animation(pop_up_scene_node, "Out")
	await get_tree().create_timer(animation_speed).timeout
	
	pop_up_scene_node.queue_free()

func animation_wiggle(target, direction):
	var tween : Tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(target, "position", direction, wiggle_speed)

func switch_to_scene(scene_to_switch_to, type):
	self.add_child(transition_scene.instantiate())
	var transition : Node = self.get_child(-1)
	
	if health >= 0:
		transition.set_labels(scene_to_switch_to.game_description, scene_to_switch_to.game_author)
		for i in max_health - health:
			transition.health_bar.get_child(i).set_texture(transition.health_broken_sprite)
	else:
		transition.clear_labels()
	
	if type == "Loss":
		transition.health_bar.get_child(max_health - health - 1).set_texture(transition.health_sprite)
	
	transition_animation(transition, "In")
	await get_tree().create_timer(transition_hold_duration).timeout
	
	if type == "Loss":
		for i in max_health - health:
			var current_heart : Node = transition.health_bar.get_child(i)
			current_heart.set_texture(transition.health_broken_Sprite)
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
	self.add_child(scene_to_switch_to)
	move_child(scene_to_switch_to, 0)
	
	transition_animation(transition, "Out")
	await get_tree().create_timer(animation_speed).timeout
	transition.queue_free()

func restart():
	self.add_child(game_over_scene.instantiate())
	var game_over_scene_instance : Node = self.get_child(-1)
	game_over_scene_instance.position.y = get_viewport().get_visible_rect().size.y
	
	transition_animation(game_over_scene_instance, "In")
	await get_tree().create_timer(transition_loss_hold_duration).timeout
	
	self.get_child(0).queue_free()
	self.add_child(main_menu_scene.instantiate())
	move_child(self.get_child(-1), 0)
	
	transition_animation(game_over_scene_instance, "Out")
	await get_tree().create_timer(animation_speed).timeout
	game_over_scene_instance.queue_free()

func game_end(status):
	match status:
		"Win":
			play_animation("Win")
			await get_tree().create_timer(outcome_hold_duration).timeout
			load_random_game("Win")
		"Loss":
			health -= 1
			play_animation("Loss")
			await get_tree().create_timer(outcome_hold_duration).timeout
			load_random_game("Loss")

func start_game():
	health = max_health
	load_random_game("Win")

func load_random_game(type):
	var random_directory : String = Array(ResourceLoader.list_directory(scenes_directory)).pick_random()
	var random_game = load(scenes_directory + random_directory + "Game.tscn")
	var loaded_instance = random_game.instantiate()
	switch_to_scene(loaded_instance, type)

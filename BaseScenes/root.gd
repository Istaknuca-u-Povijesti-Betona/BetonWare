extends Node

var MaxHealth : int = 3
var Health : int = MaxHealth
var WindowSize : Vector2
var ScenesDirectory : String = "res://Games/"
var MainMenuScene : PackedScene = preload("res://BaseScenes/StartScreen.tscn")
var TransitionScene : PackedScene = preload("res://BaseScenes/TransitionScene.tscn")
var PopUpScene : PackedScene = preload("res://BaseScenes/PopUpAnimationSprite.tscn")
var GameOverScene : PackedScene = preload("res://BaseScenes/game_over.tscn")

var AnimationSpeed : float = 0.5
var WiggleSpeed : float = 0.10
var OutcomeHoldDuration : float = 0.75
var TransitionHoldDuration : float = 0.75
var TransitionLossHoldDuration : float = 1.0

func _ready():
	pass

func transition_animation(Target, Direction):
	WindowSize = get_viewport().get_visible_rect().size
	var tween : Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	match Direction:
		"In":
			Target.position.y = WindowSize.y
			tween.tween_property(Target, "position", Vector2.ZERO, AnimationSpeed)
		"Out":
			tween.tween_property(Target, "position", Vector2(0, 0 - WindowSize.y), AnimationSpeed)

func play_animation(Type):
	self.add_child(PopUpScene.instantiate())
	var PopUpSceneNode : Node = self.get_child(-1)
	match Type:
		"Win":
			PopUpSceneNode.Sprite.set_texture(load("res://Resources/Textures/Checkmark.svg"))
		"Loss":
			PopUpSceneNode.Sprite.set_texture(load("res://Resources/Textures/Cross.svg"))
	
	transition_animation(PopUpSceneNode, "In")
	await get_tree().create_timer(OutcomeHoldDuration).timeout
	transition_animation(PopUpSceneNode, "Out")
	await get_tree().create_timer(AnimationSpeed).timeout
	
	PopUpSceneNode.queue_free()

func animation_wiggle(Target, Direction):
	var tween : Tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(Target, "position", Direction, WiggleSpeed)

func switch_to_scene(SceneToSwitchTo, Type):
	self.add_child(TransitionScene.instantiate())
	var Transition : Node = self.get_child(-1)
	
	if Health >= 0:
		Transition.set_labels(SceneToSwitchTo.GameDescription, SceneToSwitchTo.GameAuthor)
		for i in MaxHealth - Health:
			Transition.HealthBar.get_child(i).set_texture(Transition.HealthBrokenSprite)
	else:
		Transition.clear_labels()
	
	if Type == "Loss":
		Transition.HealthBar.get_child(MaxHealth - Health - 1).set_texture(Transition.HealthSprite)
	
	transition_animation(Transition, "In")
	await get_tree().create_timer(TransitionHoldDuration).timeout
	
	if Type == "Loss":
		for i in MaxHealth - Health:
			var CurrentHeart : Node = Transition.HealthBar.get_child(i)
			CurrentHeart.set_texture(Transition.HealthBrokenSprite)
			var HeartPosition : Vector2 = Transition.HealthBar.get_child(i).position
			animation_wiggle(CurrentHeart, Vector2(HeartPosition.x - 10, 0))
			await get_tree().create_timer(0.10).timeout
			animation_wiggle(CurrentHeart, Vector2(HeartPosition.x + 10, 0))
			await get_tree().create_timer(0.10).timeout
			animation_wiggle(CurrentHeart, Vector2(HeartPosition.x, 0))
		await get_tree().create_timer(0.50).timeout
		
		if Health == 0:
			restart()
	
	self.get_child(0).queue_free()
	self.add_child(SceneToSwitchTo)
	move_child(SceneToSwitchTo, 0)
	
	transition_animation(Transition, "Out")
	await get_tree().create_timer(AnimationSpeed).timeout
	Transition.queue_free()

func restart():
	self.add_child(GameOverScene.instantiate())
	var GameOverSceneInstance : Node = self.get_child(-1)
	GameOverSceneInstance.position.y = get_viewport().get_visible_rect().size.y
	
	transition_animation(GameOverSceneInstance, "In")
	await get_tree().create_timer(TransitionLossHoldDuration).timeout
	
	self.get_child(0).queue_free()
	self.add_child(MainMenuScene.instantiate())
	move_child(self.get_child(-1), 0)
	
	transition_animation(GameOverSceneInstance, "Out")
	await get_tree().create_timer(AnimationSpeed).timeout
	GameOverSceneInstance.queue_free()

func game_end(Status):
	match Status:
		"Win":
			play_animation("Win")
			await get_tree().create_timer(OutcomeHoldDuration).timeout
			load_random_game("Win")
		"Loss":
			Health -= 1
			play_animation("Loss")
			await get_tree().create_timer(OutcomeHoldDuration).timeout
			load_random_game("Loss")

func start_game():
	Health = MaxHealth
	load_random_game("Win")

func load_random_game(Type):
	var RandomDirectory : String = Array(ResourceLoader.list_directory(ScenesDirectory)).pick_random()
	var RandomGame : PackedScene = load(ScenesDirectory + RandomDirectory + "Game.tscn")
	var LoadedInstance : Node = RandomGame.instantiate()
	switch_to_scene(LoadedInstance, Type)

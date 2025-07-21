extends Node

var MaxHealth = 3
var Health = MaxHealth
var ScenesDirectory = "res://Games/"
var TransitionScene = preload("res://BaseScenes/TransitionScene.tscn")
var PopUpScene = preload("res://BaseScenes/PopUpAnimationSprite.tscn")

func _ready():
	pass

func play_animation(Type):
	self.add_child(PopUpScene.instantiate())
	var PopUpSceneNode = self.get_child(-1)
	var WindowSize = PopUpSceneNode.get_size()
	PopUpSceneNode.position.y = WindowSize.y
	match Type:
		"Win":
			PopUpSceneNode.Sprite.set_texture(load("res://Resources/Textures/Checkmark.svg"))
		"Loss":
			PopUpSceneNode.Sprite.set_texture(load("res://Resources/Textures/Cross.svg"))
	var PopUpTweenIn = get_tree().create_tween()
	PopUpTweenIn.set_trans(Tween.TRANS_QUAD)
	PopUpTweenIn.set_ease(Tween.EASE_OUT)
	PopUpTweenIn.tween_property(PopUpSceneNode, "position", Vector2.ZERO, 0.5)
	
	await get_tree().create_timer(0.75).timeout
	
	var PopUpTweenOut = get_tree().create_tween()
	PopUpTweenOut.set_trans(Tween.TRANS_QUAD)
	PopUpTweenOut.set_ease(Tween.EASE_IN)
	PopUpTweenOut.tween_property(PopUpSceneNode, "position", Vector2(0, 0 - WindowSize.y), 0.5)
	
	await get_tree().create_timer(0.5).timeout
	
	PopUpSceneNode.queue_free()

func switch_to_scene(SceneToSwitchTo, Type):
	self.add_child(TransitionScene.instantiate())
	var Transition = self.get_child(-1)
	var WindowSize = Transition.get_size()
	Transition.position.y = WindowSize.y
	
	Transition.GameLabel.text = SceneToSwitchTo.GameDescription
	Transition.DeveloperLabel.text = SceneToSwitchTo.GameAuthor
	for i in 3 - Health:
		Transition.HealthBar.get_child(i).set_texture(Transition.HealthBrokenSprite)
	
	var TransitionTweenIn = get_tree().create_tween()
	TransitionTweenIn.set_trans(Tween.TRANS_QUAD)
	TransitionTweenIn.set_ease(Tween.EASE_OUT)
	TransitionTweenIn.tween_property(Transition, "position", Vector2.ZERO, 0.5)
	
	await get_tree().create_timer(0.75).timeout
	
	if Type == "Loss":
		Health -= 1
		for i in MaxHealth - Health:
			Transition.HealthBar.get_child(i).set_texture(Transition.HealthBrokenSprite)
			#var DamageTween = get_tree().create_tween()	#TODO: Fix this animation and make it work
			#DamageTween.set_trans(Tween.TRANS_QUAD)
			#DamageTween.set_ease(Tween.EASE_OUT)
			#DamageTween.tween_property(Transition.HealthBar.get_child(i), "position", Vector2(10, 0), 0.25)
			#await get_tree().create_timer(0.25).timeout
			#DamageTween.tween_property(Transition.HealthBar.get_child(i), "position", Vector2(-10, 0), 0.25)
			#await get_tree().create_timer(0.25).timeout
			#DamageTween.tween_property(Transition.HealthBar.get_child(i), "position", Vector2(-10, 0), 0.25)
		await get_tree().create_timer(0.50).timeout
		if Health <= 0:
			pass	#TODO: end game
	
	self.get_child(0).queue_free()
	self.add_child(SceneToSwitchTo)
	move_child(SceneToSwitchTo, 0)
	
	var TransitionTweenOut = get_tree().create_tween()
	TransitionTweenOut.set_trans(Tween.TRANS_QUAD)
	TransitionTweenOut.set_ease(Tween.EASE_IN)
	TransitionTweenOut.tween_property(Transition, "position", Vector2(0, 0 - WindowSize.y), 0.5)
	await get_tree().create_timer(0.5).timeout
	Transition.queue_free()

func game_end(Status):
	match Status:
		"Win":
			play_animation("Win")
			await get_tree().create_timer(1.00).timeout
			load_random_game("Win")
		"Loss":
			play_animation("Loss")
			await get_tree().create_timer(1.00).timeout
			load_random_game("Loss")

func start_game():
	Health = MaxHealth
	load_random_game("Win")

func load_random_game(Type):
	var RandomDirectory = Array(ResourceLoader.list_directory(ScenesDirectory)).pick_random()
	var RandomGame = load(ScenesDirectory + RandomDirectory + "Game.tscn")
	var LoadedInstance = RandomGame.instantiate()
	switch_to_scene(LoadedInstance, Type)

extends CharacterBody2D

@onready var character_sprite : Node = $CharacterSprite

var move_speed : float = 250.0
var jump_speed : float = 400.0
var fall_speed : float = 400.0

const GRAVITY : float = 1000.0

func _physics_process(delta):
	apply_gravity(delta)
	
	handle_movement()
	handle_jump()
	
	move_and_slide()
	
	flip_character()

func apply_gravity(delta):
	velocity.y += GRAVITY * delta

func handle_movement():
	var movement_direction : float = Input.get_axis("LEFT", "RIGHT")
	
	velocity.x = 0.0
	
	if movement_direction < 0:
		velocity.x = 0 - move_speed
	if movement_direction > 0:
		velocity.x = 0 + move_speed

func handle_jump():
	if Input.is_action_just_pressed("SPACEBAR") == true and is_on_floor() == true:
		velocity.y = -jump_speed
	
	clampf(velocity.y, -jump_speed, fall_speed)

func flip_character():
	if velocity.x > 0:
		character_sprite.flip_h = false
	if velocity.x < 0:
		character_sprite.flip_h = true

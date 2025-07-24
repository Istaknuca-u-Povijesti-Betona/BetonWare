extends CharacterBody2D

var move_speed : float = 150.0
var jump_speed : float = -400.0
var fall_speed : float = 400.0

const GRAVITY : float = 1000.0

func _physics_process(delta):
	apply_gravity(delta)

func apply_gravity(delta : float):
	velocity.y += GRAVITY * delta

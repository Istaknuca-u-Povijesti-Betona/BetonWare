extends Camera3D

var ray : Node

func _ready():
	ray = $RayCast
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate(Vector3.DOWN, event.relative.x * 0.001)
		rotate_object_local(Vector3.LEFT, event.relative.y * 0.001)
	
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if ray.get_collider() != null:
			ray.get_collider().get_parent().hit()

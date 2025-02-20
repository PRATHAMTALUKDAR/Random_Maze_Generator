extends KinematicBody


var v = Vector3()
var speed = 5

func _physics_process(delta):
	v = Vector3(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		0,
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	move_and_slide(v*speed)

class_name PlayerCamera extends Camera2D

const LERP_WEIGHT: float = 6.0

var target: Node2D = null

func _physics_process(delta: float) -> void:
	_follow_camera_target(delta)
	
func _follow_camera_target(delta: float) -> void:
	if not target:
		return
	
	var new_camera_pos: Vector2
	new_camera_pos.x = lerp(global_position.x, target.global_position.x, LERP_WEIGHT * delta)
	new_camera_pos.y = lerp(global_position.y, target.global_position.y, LERP_WEIGHT * delta)
	
	global_position = new_camera_pos

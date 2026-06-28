class_name LevelExit extends Area2D


signal exited_level

# Collision layer/mask handles selecting only the player
func _on_body_entered(body: Node2D) -> void:
	exited_level.emit()

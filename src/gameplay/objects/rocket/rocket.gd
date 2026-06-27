class_name Rocket extends Area2D


const ROCKET_EXPLOSION = preload("uid://bjmvfsc4je7wt")

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var velocity: Vector2

func _physics_process(_delta: float) -> void:
	global_position += velocity

# When rocket hits something
func _on_body_entered(_body: Node2D) -> void:
	var rocket_explosion_scene: RocketExplosion = ROCKET_EXPLOSION.instantiate() as RocketExplosion
	assert(rocket_explosion_scene != null, "Failed to instantiate rocket explosion scene")
	
	rocket_explosion_scene.global_position = collision_shape_2d.global_position
	Globals.entity_root.add_child.call_deferred(rocket_explosion_scene)
	
	queue_free()

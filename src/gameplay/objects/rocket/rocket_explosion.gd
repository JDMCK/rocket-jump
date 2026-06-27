class_name RocketExplosion extends Node2D


@export var blast_radius: float
@export var blast_strength: float
@export var blast_effect_curve: Curve

@onready var blast_cast: ShapeCast2D = $BlastCast

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var circle: CircleShape2D = blast_cast.shape as CircleShape2D
	assert(circle != null, "Blast cast has no shape")
	circle.radius = blast_radius
	blast_cast.force_shapecast_update()
	
	_calculate_explosion.call_deferred()

func _draw() -> void:
	if Globals.debug == true:
		draw_circle(Vector2.ZERO, blast_radius, Color.GREEN)

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()

func _calculate_explosion() -> void:
	for i in blast_cast.get_collision_count():
		var body: Node2D = blast_cast.get_collider(i) as Node2D
		var movement: Movement = body.get_node_or_null("Movement") as Movement
		if movement == null:
			continue
		_apply_knockback(body, movement)

## Applies explosion knockback to body if it has a Movement component.
func _apply_knockback(body: Node2D, movement: Movement) -> void:
	print("body p:", body.global_position, "exp p:", global_position)
	var distance_from_blast_center: float = body.global_position.distance_to(global_position)
	
	# How much the blast effected the body from 1 to 0
	# 1 means the body is centered on the blast
	# 0 means the body was not in the blast radius
	var normalized_distance: float = clamp(
		distance_from_blast_center / blast_radius,
		0.0,
		1.0
	)
	var knockback_speed: float = blast_effect_curve.sample(normalized_distance) * blast_strength
	var knockback_direction: Vector2 = global_position.direction_to(body.global_position)
	
	movement.request_knockback(knockback_direction * knockback_speed)

class_name Movement extends Node
## A stateless component that simply applies velocities to the player body
## and provides an API for basic movement commands.

@export var max_run_speed: float
@export var run_acceleration_speed: float
@export var ground_friction_speed: float
@export var max_strafe_speed: float
@export var strafe_acceleration_speed: float
@export var air_friction_speed: float
@export var knockback_friction_speed: float
@export var grounded_explosion_dampen: float
@export var jump_speed: float
@export var max_fall_speed: float
@export var body: CharacterBody2D

# Normalized input direction
var _input_direction: Vector2 = Vector2.ZERO
var _knockback_velocity: Vector2 = Vector2.ZERO
var _should_jump: bool = false
var _gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var _use_knockback_friction: bool

func _physics_process(delta: float) -> void:
	assert(body != null, "Movement component requires a CharacterBody2D")
	
	# Apply gravity
	body.velocity.y += _gravity * delta
	
	var h_friction_speed: float
	var h_acceleration_speed: float
	var h_input_speed: float
	var knockback_velocity: Vector2
	
	if body.is_on_floor():
		h_friction_speed = ground_friction_speed
		h_input_speed = max_run_speed
		h_acceleration_speed = run_acceleration_speed
	else:
		h_friction_speed = air_friction_speed
		h_input_speed = max_strafe_speed
		h_acceleration_speed = strafe_acceleration_speed
	
	knockback_velocity = _knockback_velocity
	
	if body.is_on_floor():
		_use_knockback_friction = false
	elif body.velocity.x * _input_direction.x < 0: # Player is directing opposite to current velocity
		_use_knockback_friction = false
	elif !_input_direction:
		_use_knockback_friction = false
	else:
		_use_knockback_friction = true
	
	if _use_knockback_friction:
		h_friction_speed = knockback_friction_speed
	
	if _input_direction:
		body.velocity.x = _biased_move_toward(
			body.velocity.x,
			h_input_speed * _input_direction.x,
			h_acceleration_speed,
			h_friction_speed
		)
	else:
		body.velocity.x = move_toward(body.velocity.x, 0, h_friction_speed)
	
	if _should_jump:
		body.velocity.y = jump_speed
	
	body.velocity.y = min(max_fall_speed, body.velocity.y)
	
	body.velocity += knockback_velocity
	
	# Applies delta multiplication internally
	body.move_and_slide()
	
	# Reset direction intent
	_input_direction = Vector2.ZERO
	_should_jump = false
	_knockback_velocity = Vector2.ZERO

## Sets the y velocity to jump speed if on floor.
func request_jump(is_on_floor: bool) -> void:
	_should_jump = is_on_floor

## Sets the controllable intent of movement. Other factors, such as gravity
## or collisions, will overwrite this.
func request_move_direction(direction: Vector2) -> void:
	_input_direction = direction.normalized()

## Adds velocities from explosions or hits in given direction.
func request_knockback(knockback_velocity: Vector2) -> void:
	print("kb vel:", knockback_velocity)
	_knockback_velocity += knockback_velocity
	_use_knockback_friction = true

## Moves toward value, but with different speeds depending on direction.
## Note: The logic is flipped in the negatives.
## inc_delta: The delta used when the value is increasing.
## dec_delta: The delta used when the value is decreasing.
func _biased_move_toward(from: float, to: float, inc_delta: float, dec_delta: float) -> float:
	var delta: float = inc_delta if (to > 0 and from < to) or (to < 0 and from > to) else dec_delta
	return move_toward(from, to, delta)

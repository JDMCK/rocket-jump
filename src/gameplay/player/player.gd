class_name Player extends CharacterBody2D


signal died

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var coyote_timer: CoyoteTimerComponent = $CoyoteTimer
@onready var movement: Movement = $Movement
@onready var rocket_launcher: RocketLauncher = $RocketLauncher
@onready var hit_box: HitBox = $HitBox

func _physics_process(delta: float) -> void:
	_move_player(delta)
	_handle_rocket()

## Sets ammunition capacity for the player's rocket launcher (set by level via config).
func set_ammo_cap(ammo_cap: int) -> void:
	rocket_launcher.ammo_capacity = ammo_cap

func _move_player(_delta: float) -> void:
	var input_direction: Vector2 = Vector2(Input.get_axis("left", "right"), 0)
	#
	if Input.is_action_just_pressed("jump"):
		# TODO: Add jump buffering
		movement.request_jump(coyote_timer.is_on_floor)
		
	movement.request_move_direction(input_direction)
	
	if input_direction.x < 0:
		sprite.flip_h = true
	elif input_direction.x > 0:
		sprite.flip_h = false

func _handle_rocket() -> void:
	if Input.is_action_just_pressed("primary"):
		var cursor_pos: Vector2 = get_viewport().get_mouse_position()
		var canvas_player_pos: Vector2 = get_global_transform_with_canvas().origin
		var aim_direction: Vector2 = canvas_player_pos.direction_to(cursor_pos)
		rocket_launcher.fire(aim_direction)


func _on_hit_box_body_entered(body: Node2D) -> void:
	hit_box.kill()
	hit_box.spawn_death_smoke()
	died.emit()

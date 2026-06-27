class_name RocketLauncher extends Launcher


signal fired(ammo_remaining: int, ammo_capacity: int)
signal cooled_down(ammo_remaining: int)

const ROCKET = preload("uid://clk57xuraj6a2")

@export var config: RocketLauncherConfig

## Maximum ammunition capacity (to be set by player based on level config).
var ammo_capacity: int = 0:
	set(value):
		ammo_capacity = clamp(value, 0, value)

var _ammo_remaining: int
var _ready_to_fire: bool = false

func _ready() -> void:
	# Set attributes of cooldown timer
	cooldown.wait_time = config.cooldown_sec
	cooldown.one_shot = true

## Fires rocket in given direction.
## Note: Will not fire if cooldown has not finished yet.
func fire(direction: Vector2) -> void:
	if cooldown.time_left:
		return
		
	var rocket_scene: Rocket = ROCKET.instantiate() as Rocket
	assert(rocket_scene != null, "Failed to instantiate rocket scene")
	
	rocket_scene.global_position = muzzle.global_position
	rocket_scene.velocity = direction * config.rocket_speed
	rocket_scene.rotate(direction.angle())
	
	Globals.entity_root.add_child(rocket_scene)
	
	cooldown.start()
	
	fired.emit(_ammo_remaining, ammo_capacity)

func can_fire() -> bool:
	return _ready_to_fire

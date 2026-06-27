class_name CoyoteTimerComponent extends Timer


## The amount of time in seconds the body will be considered on the floor after
## leaving the floor.
@export var coyote_time_sec: float = 0.15
## The Character2D body that will experience coyote time.
@export var body: CharacterBody2D

var is_on_floor: bool = false

func _physics_process(_delta: float) -> void:
	assert(body != null, "Coyote timer requires a CharacterBody2D")
	
	if body.is_on_floor():
		is_on_floor = true
		self.start(coyote_time_sec)


func _on_timeout() -> void:
	is_on_floor = false

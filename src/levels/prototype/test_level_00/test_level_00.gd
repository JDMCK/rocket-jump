extends Level


@onready var player_spawn: Marker2D = $LevelObjects/PlayerSpawn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func get_player_spawn() -> Vector2:
	return player_spawn.global_position

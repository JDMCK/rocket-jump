class_name Level extends Node
## Class for all levels. Can be extended if special handling is needed.

signal exited_level

@export var ammo_capacity: int
@export var has_rocket_launcher: bool = true

@onready var player_spawn: Marker2D = $LevelObjects/PlayerSpawn
@onready var level_exit: LevelExit = $LevelObjects/LevelExit

func _ready() -> void:
	level_exit.exited_level.connect(_on_exit_entered)

## Provides a player spawn location
func get_player_spawn() -> Vector2:
	return player_spawn.global_position

func _on_exit_entered() -> void:
	exited_level.emit()

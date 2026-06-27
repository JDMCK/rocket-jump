@abstract
class_name Level extends Node
## Abstract base class for all levels

@export var config: LevelConfig

## Provides a player spawn location
@abstract func get_player_spawn() -> Vector2

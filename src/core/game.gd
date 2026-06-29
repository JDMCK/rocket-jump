class_name Game extends Node


const PLAYER_CAMERA_SCENE = preload("uid://0imsm81omdud")
const PLAYER_SCENE = preload("uid://2jgsa2qjfdqt")

@export var levels: Array[LevelData]

var player: Player = null
var level_camera: Camera2D = null

var _current_level_scene: Level = null
var _current_level_index: int = 0:
	set(value):
		_current_level_index = clamp(value, 0, levels.size() - 1)
var _is_transitioning: bool = false

# Systems node
@onready var systems: Node = %Systems

# Game world root nodes
@onready var level_root: Node2D = %LevelRoot
@onready var entity_root: Node2D = %EntityRoot
@onready var effect_root: Node2D = %EffectRoot

# UI root notes
@onready var hud_root: Control = %HudRoot
@onready var pause_root: Control = %PauseRoot
@onready var transition_root: Control = %TransitionRoot


func _ready() -> void:
	_init_globals()
	_init_level_camera()
	load_level(levels[_current_level_index])


## Called for loading a level scene.
func load_level(level_data: LevelData) -> void:
	# Ensure level loading happens during idle time
	_deferred_load_level.call_deferred(level_data.uid)
	
func _deferred_load_level(level_scene_uid: String) -> void:
	if _current_level_scene != null:
		_unload_level()
	
	var new_level_packed : PackedScene =\
		ResourceLoader.load(level_scene_uid, "PackedScene") as PackedScene
	assert(new_level_packed != null, "Failed to load level as a packed scene: " + level_scene_uid)
		
	_current_level_scene = new_level_packed.instantiate() as Level
	assert(_current_level_scene != null, "Loaded level is not of type Level or does not exist")
		# TODO: main menu should have a fall back scene

	level_root.add_child(_current_level_scene)
	_current_level_scene.exited_level.connect(_progress_to_next_level)
	
	_load_player()
	_place_player_in_level()
	_place_camera_in_level()
	
	Globals.is_transitioning = false

func _unload_level() -> void:
		_current_level_scene.queue_free()
		_current_level_scene.exited_level.disconnect(_progress_to_next_level)
		_current_level_scene = null
		# Necessary to avoid collisions while transitioning
		player.free()
		player = null

func _init_globals() -> void:
	Globals.entity_root = entity_root
	Globals.effect_root = effect_root

## Instantiates player scene and adds it to the current level
func _load_player() -> void:
	player = PLAYER_SCENE.instantiate() as Player
	
	Globals.entity_root.add_child(player)
	player.died.connect(_place_player_in_level)

## Place player in level's player marker with levels ammo cap.
func _place_player_in_level() -> void:
	assert(player != null and _current_level_scene != null, "Failed to place player, as player or level was null")
	
	player.global_position = _current_level_scene.get_player_spawn()
	player.set_ammo_cap(_current_level_scene.ammo_capacity)
	player.set_has_rocket_launcher(_current_level_scene.has_rocket_launcher)

## Attaches level camera to player
func _init_level_camera() -> void:	
	level_camera = PLAYER_CAMERA_SCENE.instantiate() as Camera2D
	
	systems.add_child(level_camera)

## Places camera onto player in level
func _place_camera_in_level() -> void:
	assert(
		player != null and level_camera != null and _current_level_scene != null,
		"Failed to place camera, as player or level was null"
		)
	level_camera.target = player

## Progresses to the next level
func _progress_to_next_level() -> void:
	Globals.is_transitioning = true
	_current_level_index += 1
	load_level(levels[_current_level_index])

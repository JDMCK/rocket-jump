class_name Game extends Node

const TEST_LEVEL_00_UID: String = "uid://m8322hkvhvk6"
const PLAYER_CAMERA_UID: String = "uid://0imsm81omdud"
const PLAYER_UID: String = "uid://2jgsa2qjfdqt"

var player: Player = null
var level_camera: Camera2D = null

var _current_level: Level = null

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
	_init_player()
	load_level(TEST_LEVEL_00_UID)

## Called for loading a level scene.
## NOTE: The input level_scene must extend Level
func load_level(level_scene_uid: String) -> void:
	# Ensure level loading happens during idle time
	_deferred_load_level.call_deferred(level_scene_uid)
	
func _deferred_load_level(level_scene_uid: String) -> void:
	if _current_level != null:
		_current_level.queue_free()
		_current_level = null
			
	var new_level_packed : PackedScene =\
		ResourceLoader.load(level_scene_uid, "PackedScene") as PackedScene
	assert(new_level_packed != null, "Failed to load level as a packed scene: " + level_scene_uid)
		
	_current_level = new_level_packed.instantiate() as Level
	assert(_current_level != null, "Loaded level is not of type Level or does not exist")
		# TODO: main menu should have a fall back scene

	level_root.add_child(_current_level)

	_place_player_in_level()
	_setup_level_camera()

func _init_globals() -> void:
	Globals.entity_root = entity_root
	Globals.effect_root = effect_root

## Instantiates player scene and adds it to the current level
func _init_player() -> void:
	var player_scene: PackedScene = ResourceLoader.load(PLAYER_UID) as PackedScene
	assert(player_scene != null, "Failed to load player scene: " + PLAYER_UID)

	player = player_scene.instantiate() as Player
	assert(player != null, "Loaded player scene does not extend Player: " + PLAYER_UID)

	entity_root.add_child(player)

## Place player in level's player marker with levels ammo cap.
func _place_player_in_level() -> void:
	assert(player != null and _current_level != null, "Failed to place player as player or level was null")
	
	player.global_position = _current_level.get_player_spawn()
	player.set_ammo_cap(_current_level.config.ammo_capacity)

## Attaches level camera to player
func _setup_level_camera() -> void:
	assert(player != null and _current_level != null, "Failed to setup camera as player or level was null")
	
	var player_camera_scene: PackedScene = ResourceLoader.load(PLAYER_CAMERA_UID) as PackedScene
	assert(player_camera_scene != null, "Failed to load player camera scene: " + PLAYER_CAMERA_UID)

	level_camera = player_camera_scene.instantiate() as Camera2D
	assert(player != null, "Loaded player camera scene does not extend Camera2D: " + PLAYER_CAMERA_UID)
	
	level_camera.target = player
	
	systems.add_child(level_camera)

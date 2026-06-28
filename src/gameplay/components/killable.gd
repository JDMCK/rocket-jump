class_name Killable extends Node

signal died

const DEATH_SMOKE = preload("uid://s2yrbef384g8")

@onready var parent: Node2D = get_parent()

@export var animated_sprite_2D: AnimatedSprite2D

var _is_dead: bool = false

func _ready() -> void:
	assert(parent != null, "Killable must have a parent node")

func kill() -> void:
	_is_dead = true
	died.emit()

func spawn_death_smoke() -> void:
	var death_smoke_scene: DeathSmoke = DEATH_SMOKE.instantiate() as DeathSmoke
	assert(death_smoke_scene != null, "Death smoke scene failed to instantiate")
	
	death_smoke_scene.global_position = parent.global_position
	
	Globals.effect_root.add_child.call_deferred(death_smoke_scene)

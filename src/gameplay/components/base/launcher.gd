@abstract
class_name Launcher extends Node

@onready var cooldown: Timer = $CooldownTimer
@onready var muzzle: Marker2D = $Muzzle

@abstract func fire(direction: Vector2) -> void
@abstract func can_fire() -> bool

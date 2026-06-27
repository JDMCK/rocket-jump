class_name StateTracker extends Node
## Simple state tracker to track of which state the parent is in.
## No logic is run by the states themselves or this tracker.

signal transitioned(state: StringName)

@export var states: Array[StringName]

var current_state: StringName

func _ready() -> void:
	# Lowercase all states for comparison later
	for i in states.size():
		states[i] = states[i].to_lower()

## Changes from one state to another and emits a signal
func change_state(state_name: StringName) -> void:
	state_name = state_name.to_lower()
	if state_name in states:
		current_state = state_name.to_lower()
		transitioned.emit(state_name)

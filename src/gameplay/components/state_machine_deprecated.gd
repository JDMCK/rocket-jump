## NOTE:
## This state system is currently deprecated as it is way too big and not
## super compatible with my current component system.


class_name StateMachineDeprecated extends Node


@export var current_state: State

## Stores states by name.
var _states: Dictionary[String, State] = {}

func _ready() -> void:
	assert(current_state != null, "Initial state cannot be null")
	
	for child in get_children():
		if child is State:
			_states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transitioned)

func _process(delta: float) -> void:
	current_state.process(delta)

func _physics_process(delta: float) -> void:
	current_state.physics_process(delta)

## Forcefully changes current state if given state is not null.
func force_change_state(state: State) -> void:
	if state == null:
		return
	
	current_state.exit()
	current_state = state
	current_state.enter()

## Signalled by a state transitioning.
func on_child_transitioned(state: State, new_state_name: String) -> void:
	if state != current_state:
		return
	
	var new_state: State = _states[new_state_name.to_lower()]
	if state == null or new_state == null:
		return
	
	current_state.exit()
	current_state = new_state
	current_state.enter()

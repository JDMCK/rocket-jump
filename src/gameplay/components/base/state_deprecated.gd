## NOTE:
## This state system is currently deprecated as it is way too big and not
## super compatible with my current component system.

@abstract
class_name StateDeprecated extends Node
## Base class to define states that will be managed by a StateMachine.

## Emitted whenever a state decides it should no longer be the current state.
signal transitioned(state: State, new_state_name: String)

## Called when this state becomes the current state.
@abstract func enter() -> void

## Called when this state becomes no longer the current state.
@abstract func exit() -> void

## Called every physics process when this state is the current state.
@abstract func process(delta: float) -> void

## Called every process when this state is the current state.
@abstract func physics_process(delta: float) -> void

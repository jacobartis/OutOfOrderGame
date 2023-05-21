extends PlayerBaseState

#Variables 

#Dictionary of all avalible state nodes
@onready var States = {
	PlayerBaseState.State.Idle: $Idle,
	PlayerBaseState.State.Walking: $Walking,
	PlayerBaseState.State.Sliding: $Sliding,
	PlayerBaseState.State.Dead: $Dead
}

#Stores current and previous state nodes
var current_state: PlayerBaseState
var prev_state: PlayerBaseState

#Stores current and previous state dict refrences
var current_state_dict: PlayerBaseState.State
var prev_state_dict: PlayerBaseState.State

#Getters

#Returns current state
func get_state() -> PlayerBaseState:
	return current_state

#Returns previous state
func get_prev_state() -> PlayerBaseState:
	return prev_state

#Returns current state dict ref
func get_state_dict() -> PlayerBaseState.State:
	return current_state_dict

#Returns previous state dict ref
func get_prev_state_dict() -> PlayerBaseState.State:
	return prev_state_dict

#Functions

#Initialises all child states
func init(value:CharacterBody3D, sc_value:Node = null) -> void:
	body = value
	
	for child in get_children():
		if child is PlayerBaseState:
			child.init(value,self)
	
	change_state(PlayerBaseState.State.Idle)

#Handles running process in current state and reciving new states 
func process(delta) -> void:
	if !body.get_health():
		change_state(PlayerBaseState.State.Dead)
	
	if !current_state:
		return
	
	var new_state = current_state.process(delta)
	
	if new_state:
		change_state(new_state)

#Runs the current states physics processes
func physics_process(delta) -> void:
	if !current_state:
		return
	current_state.physics_process(delta)

#Runs input for the current state
func input(event) -> void:
	if !current_state:
		return
	current_state.input(event)

#Exits current state and enters given state
func change_state(new_state) -> void:
	if current_state == States[PlayerBaseState.State.Dead]:
		return
	
	if current_state:
		current_state.exit()
	
	prev_state = current_state
	prev_state_dict = current_state_dict
	
	current_state = States[new_state]
	current_state_dict = new_state
	current_state.enter()

class_name State_Walk extends State

@export var move_speed : float = 200.0
@onready var idle : State = $"../idle"
@onready var attack: State_attack = $"../attack"


# What happens when the player exits this State?
func Enter() ->void:
	player.UpdateAnimation("walk")

func Exit()->void:
	pass

# What happens during the process update in this State?
func Process( _delta : float) ->State:
	player.velocity = player.direction * move_speed
	if player.SetDirection():
		player.UpdateAnimation("walk")
	if player.velocity == Vector2.ZERO:
		return idle
	return null


# What happens during the physics process update in this State?
func Physics( _delta : float) ->State:
	return null



# What happens with input events in this State?
func HandleInput( _event : InputEvent) ->State:
	if _event.is_action_pressed("attack"):
		return attack
	return null

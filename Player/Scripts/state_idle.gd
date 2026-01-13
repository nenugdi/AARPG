class_name State_Idle extends State

@onready var walk : State = $"../walk"
@onready var attack: State_attack = $"../attack"

# What happens when the player exits this State?
func Enter() ->void:
	player.UpdateAnimation("idle")

func Exit()->void:
	pass

# What happens during the process update in this State?
func Process( _delta : float) ->State:
	if player.direction != Vector2.ZERO:
		return walk
	player.velocity = Vector2.ZERO
	return null


# What happens during the physics process update in this State?
func Physics( _delta : float) ->State:
	return null



# What happens with input events in this State?
func HandleInput( _event : InputEvent) ->State:
	if _event.is_action_pressed("attack"):
		return attack
	return null

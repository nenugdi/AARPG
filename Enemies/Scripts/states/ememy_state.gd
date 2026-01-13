class_name EnemyState extends Node

var enemy : Enemy
var enemy_state_machine : EnemyStateMachine



#what happen when enemy init this state
func Init()->void:
	pass

func Enter() ->void:
	pass
	
# What happens when the enemy exits this State?
func Exit()->void:
	pass

# What happens during the process update in this State?
func Process( _delta : float) ->EnemyState:
	return null


# What happens during the physics process update in this State?
func Physics( _delta : float) ->EnemyState:
	return null

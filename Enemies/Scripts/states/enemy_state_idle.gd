class_name EnemyStateIdle extends EnemyState

@export var anim_name : String = "idle"
@export_category("AI")
@export var state_duration_min : float =0.5
@export var state_duration_max : float =1.5
@export var after_idle_state : EnemyState 

var _timer : float = 1
#what happen when enemy init this state
func Init()->void:
	pass

func Enter() ->void:
	enemy.velocity = Vector2.ZERO
	_timer = randf_range( state_duration_min, state_duration_max)
	enemy.UpdateAnimation( anim_name )
	pass
	
# What happens when the enemy exits this State?
func Exit()->void:
	pass

# What happens during the process update in this State?
func Process( _delta : float) ->EnemyState:
	_timer -= _delta
	if _timer <= 0:
		return after_idle_state
	return null


# What happens during the physics process update in this State?
func Physics( _delta : float) ->EnemyState:
	return null

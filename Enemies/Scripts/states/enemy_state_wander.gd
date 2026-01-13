class_name EnemyStateWander extends EnemyState

@export var anim_name : String = "walk"
@export var wander_speed : float =20.0
@export_category("AI")
@export var state_animation_duration : float =0.5
@export var state_cycles_min : int = 1
@export var state_cycles_max : int = 3
@export var next_state : EnemyState

var _timer : float = 0
var _direction : Vector2

#what happen when enemy init this statew
func Init()->void:

	pass

func Enter() ->void:
	_timer = randi_range( state_cycles_min, state_cycles_max) * state_animation_duration
	var rand = randi_range( 0, 3 )
	_direction = enemy.DIR_4[ rand ]
	enemy.velocity = _direction * wander_speed
	enemy.SetDirection( _direction )
	enemy.UpdateAnimation( anim_name )
	pass
	
# What happens when the enemy exits this State?
func Exit()->void:
	pass

# What happens during the process update in this State?
func Process( _delta : float) ->EnemyState:
	_timer -= _delta
	enemy.velocity = _direction * wander_speed
	if _timer <= 0:
		return next_state
	return null


# What happens during the physics process update in this State?
func Physics( _delta : float) ->EnemyState:
	return null

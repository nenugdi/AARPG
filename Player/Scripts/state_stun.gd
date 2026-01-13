class_name State_Stun extends State

@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0
@export var invulnerable_duration : float =1.0

var hurt_box : HurtBox
var direction : Vector2
var next_state : State
@onready var idle : State = $"../idle"

func init()->void:
	player.player_damaged.connect( _player_damaged )


# What happens when the player exits this State?
func Enter() ->void:
	player.animation_player.animation_finished.connect( _amimation_finished )
	direction = player.global_position.direction_to(hurt_box.global_position) #direction为打击框的反方向
	player.velocity = direction * -knockback_speed #设置反弹速度
	player.SetDirection() #设置方向
	player.UpdateAnimation("stun") #方向确定后再播放击晕动画
	player.make_invulnerable(invulnerable_duration)
	player.effect_animation_player.play("damaged")

func Exit()->void:#清理下已有的值和信号链接，避免下次进入时出现问题
	next_state = null
	player.animation_player.animation_finished.disconnect( _amimation_finished )
	pass                                               

# What happens during the process update in this State?
func Process( _delta : float) ->State:
	player.velocity -= player.velocity *  decelerate_speed * _delta
	return next_state


# What happens during the physics process update in this State?
func Physics( _delta : float) ->State:
	return null



# What happens with input events in this State?
func HandleInput( _event : InputEvent) ->State:
	return null
	
func _player_damaged( _hurt_box : HurtBox)->void:
	hurt_box = _hurt_box
	player_state_machine.ChangeState(self)
	
func _amimation_finished( _a : String )->void:
	next_state = idle
	

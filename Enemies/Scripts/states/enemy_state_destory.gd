class_name EnemyStateDestory extends EnemyState

@export var anim_name : String = "destory"
@export var knockback_speed : float =200.0
@export var decelerate_speed : float =10.0

var _damage_position : Vector2
var _direction : Vector2
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

#what happen when enemy init this statew
func Init()->void:
	enemy.enemy_destory.connect( _on_enemy_destoried )
	pass

func Enter() ->void:
	enemy.invlunerable = true

	_direction = enemy.global_position.direction_to( _damage_position )
	enemy.SetDirection( _direction )
	enemy.velocity = _direction * -knockback_speed #注意是负值，因为上面方向是面朝player，所以移动反着走
	#print("des")
	enemy.UpdateAnimation( anim_name )
	enemy.animation_player.animation_finished.connect(_on_animation_finished)

func Exit()->void:
	enemy.invlunerable = false
	enemy.animation_player.animation_finished.disconnect(_on_animation_finished)
	pass

# What happens during the process update in this State?
func Process( _delta : float) ->EnemyState:
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null


# What happens during the physics process update in this State?
func Physics( _delta : float) ->EnemyState:
	return null
func _on_enemy_destoried( hurt_box: HurtBox)->void:
	_damage_position = hurt_box.global_position
	enemy_state_machine.ChangeState(self) #实际上会进入上面的Enter函数
	
func _on_animation_finished( _a : String) ->void:
	enemy.queue_free() #清除enemy对象

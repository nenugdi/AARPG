class_name State_attack extends State
var attacking : bool = false
@onready var walk : State = $"../walk"
@onready var idle: State_Idle = $"../idle"
#@onready var attack_effect_sprite: Sprite2D = $"../../Sprite2D/AttackEffectSprite"  考虑隐藏Sprite2D

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var attack_animation_player: AnimationPlayer = $"../../Sprite2D/AttackEffectSprite/AnimationPlayer"

#攻击的声音存储在attack_sound流里面，需要播放时audio调用
@export var attack_sound : AudioStream
@onready var audio: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"
@onready var hurt_box: HurtBox = $"../../Sprite2D/AttackHurtBox"

#定义攻击过程中的减速系数，在攻击时玩家应该也能移动，但是比正常移动慢
@export_range(1,20,0.5) var decelerate_speed : float = 5.0
# What happens when the player exits this State?
func Enter() ->void:
	#attack_effect_sprite.visible = true
	player.UpdateAnimation("attack") #player整体动画播放器
	attack_animation_player.play("attack_" + player.AnimationDirection())#攻击动画专用播放器
	animation_player.animation_finished.connect(EndAttack) #动画播放完毕，结束attack状态
	
	audio.stream = attack_sound #播放器的流定义，这样做好处是在每个不同的动作内部定义声音文件
	audio.pitch_scale = randf_range(0.9,1.1) #随机高低音
	audio.play() #播放音乐
	attacking = true
	
	await get_tree().create_timer(0.0075).timeout
	hurt_box.monitoring = true

func Exit()->void:
	#attack_effect_sprite.visible = false
	animation_player.animation_finished.disconnect(EndAttack)
	attacking = false
	hurt_box.monitoring = false
	pass

# What happens during the process update in this State?
func Process( _delta : float) ->State:
	#玩家在攻击状态下，
	player.velocity -= player.velocity * decelerate_speed * _delta
	if attacking == false  :
		if player.velocity == Vector2.ZERO:
			return idle
		else:
			return walk
		
	return null


# What happens during the physics process update in this State?
func Physics( _delta : float) ->State:
	return null



# What happens with input events in this State?
func HandleInput( _event : InputEvent) ->State:
	return null

func EndAttack( _newAnimationName : String )->void:
	attacking = false

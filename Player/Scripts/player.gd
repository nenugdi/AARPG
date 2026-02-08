class_name Player extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
@onready var state_machine : PlayerStateMachine = $StateMachine
const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var effect_animation_player: AnimationPlayer = $EffectAnimationPlayer


@onready var hit_box: HitBox = $HitBox

signal DirectionChanged( new_direction : Vector2)
signal player_damaged( hurt_box : HurtBox )

var invulnerable : bool = false
var hp : int = 6
var max_hp :int = 6
	 

func _ready() -> void:
	Engine.max_fps = 60 #控制帧率为60
	PlayerManager.player = self
	state_machine.Initialize(self)
	hit_box.Damaged.connect( _take_damage )
	update_hp(99)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	direction = Input.get_vector("left","right","up","down") 
	#direction = Input.get_vector("left","right","up","down")
	#velocity = direction * 200
	#if SetState() == true || SetDirection() == true:
		##if cardinal_direction == Vector2.LEFT: #没有做左侧方向动画，因此当左触发，把精灵翻转
			##$Sprite2D.flip_h =1
		##else:
			##$Sprite2D.flip_h =0
		#UpdateAnimation()
	#$Sprite2D.rotation += 0.1
	pass

func _physics_process(delta: float) -> void:
	move_and_slide()
		
func SetDirection()->bool:
	if direction == Vector2.ZERO:
		return false
	var direction_id : int = int(round( (direction+cardinal_direction*0.1).angle()/TAU * DIR_4.size()))
	var new_dir : Vector2 = DIR_4[ direction_id ]
	if new_dir == cardinal_direction:
		return false
	cardinal_direction = new_dir
	DirectionChanged.emit( new_dir )
	$Sprite2D.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true
	
	
func UpdateAnimation(state : String):
	$AnimationPlayer.play(state + "_" + AnimationDirection() )
	
	
func AnimationDirection()-> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"
	
func _take_damage( hurt_box : HurtBox ) ->void:
	if invulnerable == true:
		return
	update_hp( -hurt_box.damage )
	if hp > 0:
		player_damaged.emit(hurt_box)
	else:
		player_damaged.emit(hurt_box)
		update_hp(99)	
	pass

func update_hp( delta : int )->void:
	hp = clamp( hp + delta, 0, max_hp )
	PlayerHud.update_hp(hp,max_hp)
	pass
	
func make_invulnerable( _duration : float = 1.0 )->void:
	invulnerable = true
	hit_box.monitoring = false
	await get_tree().create_timer( _duration ).timeout #无敌计时器，时间结束执行后续语句
	invulnerable = false
	hit_box.monitoring = true
	pass

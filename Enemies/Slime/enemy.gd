class_name Enemy extends CharacterBody2D

signal  direction_changed(new_direction : Vector2)
signal enemy_damage( hurt_box : HurtBox )
signal enemy_destory( hurt_box : HurtBox )
const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

@export var hp : int = 4

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var player : Player #看不出用途
var invlunerable : bool = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var hit_box: HitBox = $HitBox
@onready var enemy_state_machine: EnemyStateMachine = $EnemyStateMachine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_state_machine.initialize(self)
	player = PlayerManager.player #这个player暂时没什么用，不知道作者为什么在Slime里创造一个player对象
	hit_box.Damaged.connect( _take_damage )
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _physics_process(delta: float) -> void:
	move_and_slide()
	
	
	
func SetDirection(_new_direction : Vector2)->bool:
	direction = _new_direction
	if direction == Vector2.ZERO:
		return false
   
	var direction_id : int = int(round( (direction+cardinal_direction*0.1).angle()/TAU * DIR_4.size()))
	var new_dir : Vector2 = DIR_4[ direction_id ]
	if new_dir == cardinal_direction:
		return false
	cardinal_direction = new_dir
	#DirectionChanged.emit( new_dir )
	$Sprite2D.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true
	
	
func UpdateAnimation(state : String):
	animation_player.play(state + "_" + AnimationDirection() )
	
	
func AnimationDirection()-> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"

func _take_damage( hurt_box : HurtBox ) ->void:	
	if invlunerable == true:
		return
	hp -= hurt_box.damage
	#print(hp)
	if hp>0:
		enemy_damage.emit(hurt_box)
	else:
		enemy_destory.emit(hurt_box)
	

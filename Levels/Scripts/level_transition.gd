@tool
class_name LevelTransition extends Area2D

enum SIDE{LEFT,RIGHT,TOP,BOTTOM}

@export_file( "*.tscn" ) var level
@export var target_transiton_area : String = "LevelTransition"

@export_category("COllision Area Settings")

@export_range(1,12,1,"or_greater") var size : int =2:
	set( _value ):
		size = _value
		_update_area()

@export var side : SIDE = SIDE.LEFT :
	set( _value ):
		side = _value
		_update_area()

@export var snap_to_grid : bool = false:
	set( _value ):
		snap_to_grid = _value
		_snap_to_grid()
		

@onready var collision_shape : CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	_update_area()
	if Engine.is_editor_hint(): #在 @tool 脚本中，避免执行运行时特定代码（如连接信号、访问 Autoload）：
		return
	monitoring = false
	_place_player()#_place_player函数是属于新场景的，根据新场景的门，计算玩家位置
	#下面这句必须有，场景加载完成才能监控monitoring，不然会重复进出场景二次
	await LevelManager.level_loaded
	monitoring = true
	#玩家进入LeverTransition的碰撞区，触发地图转换，注意下面的函数body_entered.connect( _player_entered) 是老场景的，老场景的门
	body_entered.connect( _player_entered) # 继承自Area2D的信号
	pass # Replace with function body.

func _player_entered( _p : Node2D) ->void:
	#这个load_new_level函数执行的过程中等待了2帧，将老场景销毁了
	LevelManager.load_new_level( level, target_transiton_area,get_offset())
	pass

func _place_player()->void:
	if name != LevelManager.target_transition:
		return
	PlayerManager.set_player_position(global_position + LevelManager.position_offset)

#此函数的目的是记录玩家和门的相对置，将其传回LevelManger保存，进入新场景后，玩家和门相对位置保持不变
func get_offset()->Vector2:
	var diff: Vector2 =  PlayerManager.player.global_position - global_position
	match side: #至于加减16，是因为吸附最小单位是16*16，这样可以避免玩家传送过来后又进入这个门，反复切换
		SIDE.LEFT:
			return Vector2(-16, diff.y)
		SIDE.RIGHT:
			return Vector2(16, diff.y)
		SIDE.TOP:
			return Vector2(diff.x, -16)
		SIDE.BOTTOM:
			return Vector2(diff.x, 16)
		_:
			return Vector2.ZERO
	
#函数的作用是把关卡过渡的碰撞体根据位置变宽变窄
func _update_area()->void:
	var new_rect : Vector2 = Vector2(32,32)
	var new_positon : Vector2 = Vector2.ZERO
	if side == SIDE.TOP:
		new_rect.x *= size
		new_positon.y -= 16
	elif side == SIDE.BOTTOM:
		new_rect.x *= size
		new_positon.y += 16
	elif side == SIDE.LEFT:
		new_rect.y *= size
		new_positon.x -= 16
	elif side == SIDE.RIGHT:
		new_rect.y *= size
		new_positon.x += 16
	if collision_shape == null:
		collision_shape = get_node("CollisionShape2D")
	collision_shape.shape.size = new_rect
	collision_shape.position = new_positon

#网格吸附功能，作用是坐标对齐网格
func _snap_to_grid()->void:
	position.x = round(position.x/ 16)*16
	position.y = round(position.y/ 16)*16
	
	
	
	
	

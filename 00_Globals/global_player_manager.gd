extends Node

const PLAYER = preload("uid://l223k0nuf2s5")

const INVENTORY_DATA : InventoryData = preload("uid://u7feyror3ddy")

var player : Player
var player_spawned : bool = false

func _ready() -> void:
	add_player_instance()
	#下面是个安全机制
	await get_tree().create_timer(0.5).timeout
	player_spawned = true

func add_player_instance()->void:
	player = PLAYER.instantiate()
	add_child(player)


func set_player_position( _new_pos : Vector2)->void:
	player.global_position = _new_pos
	
func set_health( hp : int, max_hp : int )->void:
	player.max_hp = max_hp
	player.hp = hp
	player.update_hp(0) #用函数目的，刷新UI，playerhub这些
	
func set_as_playerparent( _parent : Node2D)->void:
	#var pos = player.global_position #先记录原始位置
	if player.get_parent():
		player.get_parent().remove_child(player)
	_parent.add_child(player)
	#player.global_position = pos #更改父节点后，位置会相对父节点便宜，变回原始位置
	
func unparent_player( _parent:Node2D )->void:
	_parent.remove_child(player)
	

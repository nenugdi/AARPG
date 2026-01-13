extends Node

signal level_load_started #加载开始
signal level_loaded  #加载完成
signal TileMapBoundsChanged(bounds : Array[Vector2])

var current_tilemap_bounds : Array[Vector2] 
var target_transition : String
var position_offset : Vector2

#全局的ready主要是为第一个场景准备，但是没有这个函数也没所谓
func _ready() -> void:
	await get_tree().process_frame
	level_loaded.emit()



func ChangeTilemapBounds(bounds : Array[Vector2])->void:
	current_tilemap_bounds = bounds
	TileMapBoundsChanged.emit(bounds)
	
	
func load_new_level(
		level_path : String,
		_target_transition : String,
		_position_offset : Vector2
)->void:
	get_tree().paused = true #场景切换期间，暂停游戏，避免玩家收到伤害
	target_transition = _target_transition
	position_offset = _position_offset
	
	await SceneTransition.fade_out()
	level_load_started.emit()
	get_tree().change_scene_to_file(level_path)
	await SceneTransition.fade_in() 

	get_tree().paused = false
	await  get_tree().process_frame#等待一帧时间
	
	level_loaded.emit()
	pass

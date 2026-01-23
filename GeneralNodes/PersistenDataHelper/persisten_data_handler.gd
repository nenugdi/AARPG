#数据持久化，宝箱、开关门，任务npc等
class_name PersistemDataHandler extends Node 

signal data_loaded
var value : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print(_get_name())
	get_value()
	

func set_value()->void:
	SaveManager.add_persistent_value(_get_name())
	pass
	
	
func get_value()->void:
	value = SaveManager.check_persistent_value( _get_name() )
	data_loaded.emit()
	pass
	
	
func _get_name()->String :
	#res://levels/area01/01.tscn
	return get_tree().current_scene.scene_file_path+"/"+get_parent().name+"/"+name
	
	

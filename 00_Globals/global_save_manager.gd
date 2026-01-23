extends Node

const SAVE_PATH = "user://"
const SAVE_FILE = "save.sav"
signal game_loaded
signal game_saved
#Dictionary类型是字典树结构，类似C++的map
var current_save : Dictionary = {
	scene_path = "",
	player = {
		hp = 1,
		max_hp = 1,
		pos_x = 0,
		pos_y = 0
	},
	items = [],
	persistence = [],
	quese = [],
}

func save_game()->void:
	update_player_data()
	update_scene_path()
	update_item_data()
	var file : = FileAccess.open(SAVE_PATH+SAVE_FILE,FileAccess.WRITE)
	#print("user:// 实际映射到: ", ProjectSettings.globalize_path("user://"))
	var save_json = JSON.stringify(current_save)
	file.store_line(save_json)
	game_saved.emit()
	
func load_game()->void:
	var file : = FileAccess.open(SAVE_PATH+"save.sav",FileAccess.READ)
	if file == null:
		var error = FileAccess.get_open_error()
		push_error("❌ 文件打开失败: " + error_string(error))
	var json_data = JSON.parse_string(file.get_as_text())
	current_save = json_data
	
	LevelManager.load_new_level( current_save.scene_path, "", Vector2.ZERO )
	await LevelManager.level_load_started
	PlayerManager.set_player_position( Vector2(current_save.player.pos_x, current_save.player.pos_y) )
	PlayerManager.set_health( current_save.player.hp, current_save.player.max_hp)
	PlayerManager.INVENTORY_DATA.parse_save_data(current_save.items)
	await LevelManager.level_loaded
	game_loaded.emit() #暂时不知道有什么用
	
	
func update_player_data()->void:
	var p : Player = PlayerManager.player
	current_save.player.hp = p.hp
	current_save.player.max_hp = p.max_hp
	current_save.player.pos_x = p.global_position.x
	current_save.player.pos_y = p.global_position.y
	
func update_scene_path()->void:
	var p : String = ""
	for c in get_tree().root.get_children():
		if c is Level:
			p = c.scene_file_path
			current_save.scene_path = p
			
func update_item_data()->void:
	current_save.items = PlayerManager.INVENTORY_DATA.get_save_data()
	
	
func add_persistent_value( value : String )->void:
	if check_persistent_value(value) == false:
		current_save.persistence.append(value)
	pass
	
func check_persistent_value( value : String )->bool:
	var p = current_save.persistence as Array
	return p.has(value)
	
	

class_name InventoryUI extends Control #GridContainer对应的脚本

const INVENTORY_SLOT = preload("uid://bmhdevn0urorx") #InventorySlot场景，用于生成物品按钮

@export var data : InventoryData #InventoryData类型包含slots数组，大小为10也就是物品数组

func _ready() -> void:
	PauseMenu.shown.connect(update_inventory) #PauseMenu是全局类
	PauseMenu.hidden.connect(clear_inventory)
	clear_inventory()
	data.changed.connect( on_inventory_changed ) #data发生变化，重新刷新GridContainer
	pass
	
	
func clear_inventory()->void:
	for c in get_children():
		c.queue_free()

#当调用暂停菜单时，执行函数，装入道具
func update_inventory()->void:
	for s in data.slots: #数组大小可变
		var new_slot = INVENTORY_SLOT.instantiate()
		add_child(new_slot)
		new_slot.slot_data = s
	await get_tree().process_frame #d
	get_child(0).grab_focus() #每次打开菜单，焦点默认锁定第一个物品
	


func on_inventory_changed()->void:
	clear_inventory()
	update_inventory()
	

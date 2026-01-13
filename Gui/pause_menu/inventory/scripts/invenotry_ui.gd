class_name InventoryUI extends Control #GridContainer对应脚本

const INVENTORY_SLOT = preload("uid://bmhdevn0urorx") #InventorySlot场景，也就是道具按钮

@export var data : InventoryData #InventoryData默认数组SlotData大小为10
var foucs_index : int
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
		new_slot.focus_entered.connect( item_focused )
	get_child(0).grab_focus()


func on_inventory_changed()->void:
	clear_inventory()
	update_inventory()
	get_child(foucs_index).grab_focus()
	
func item_focused()->void:
	for i in get_child_count():
		if get_child(i).has_focus():
			foucs_index = i
			return
	pass

class_name InventoryData extends Resource #GridContainer中的物品集合，本质是一个物品数组，以常量形式存在于GridContainer,

@export var slots :Array [SlotData]

func _init() -> void:
	connect_slots()
	pass

func add_item(item : ItemData, count : int = 1)->bool:
	for s in slots:
		if s:
			if s.item_data == item:
				s.quantity += count
				return true
	
	for i in slots.size(): #i从0开始
		if slots[i] == null:
			var newslot = SlotData.new()
			newslot.item_data = item
			newslot.quantity = count
			slots[i] = newslot
			newslot.changed.connect( slot_changed )
			return true
			
	print("背包已满")
	return false


func connect_slots()->void:
	for s in slots:
		if s:
			s.changed.connect(slot_changed)

func slot_changed()->void: #只改变这里并不会改变GridContainer，必须在GridContainer刷新
	for s in slots:
		if s:
			if s.quantity<1:
				s.changed.disconnect( slot_changed )
				var index = slots.find(s)
				slots[index] = null
				emit_changed() #系统信号，资源变化应该调用
				
#物品放入数组
func get_save_data()->Array:
	var item_save : Array = []
	for i in slots.size():
		item_save.append( item_to_save(slots[i]) )
	return item_save
	
#把物品信息放入字典
func item_to_save( slot : SlotData )->Dictionary:
	var result = { path ="",quantity=0}
	if slot != null:
		result.quantity = slot.quantity
		if slot.item_data != null:
			result.path = slot.item_data.resource_path #调用对应资源的存储路径
	return result
				
func parse_save_data( save_data : Array)->void:
	var array_size = slots.size()
	slots.clear() #长度归零
	slots.resize(array_size) #此时空数据
	for i in save_data.size():
		slots[i] = item_from_save( save_data[i] )
	connect_slots() #连接

func item_from_save( save_object : Dictionary )->SlotData:
	if save_object.path == "": #和视频不一样，存储的是path标签
		return null
	var new_slot : SlotData =SlotData.new()
	new_slot.item_data = load(save_object.path ) 
	new_slot.quantity = int(save_object.quantity)
	return new_slot

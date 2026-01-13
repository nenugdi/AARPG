class_name InventoryData extends Resource

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
				emit_changed()

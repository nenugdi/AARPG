class_name SlotData extends Resource
#此类不生成实例，配合生成背包和物品数据
@export var item_data : ItemData
@export var quantity : int = 0 : set = set_quantity


func set_quantity( value : int )->void:
	quantity = value
	if quantity<1:
		emit_changed()

class_name InventorSlotUI extends Button

var slot_data : SlotData : set = set_slot_data #定义 setter**：当属性被赋值时，会自动调用 `set_slot_data` 方法

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label

func _ready() -> void:
	texture_rect.texture = null
	label.text = ""
	focus_entered.connect( item_focused )
	focus_exited.connect( item_unfocused)
	#连接press信号
	

func set_slot_data( value : SlotData )->void:
	slot_data = value
	if slot_data == null:
		return
	texture_rect.texture = slot_data.item_data.texture
	label.text = str(slot_data.quantity)
	
func item_focused()->void:
	if slot_data != null:
		if slot_data.item_data !=null:
			PauseMenu.update_item_description( slot_data.item_data.description)
	pass

func item_unfocused()->void:
	PauseMenu.update_item_description( "空" )
	pass


func _on_pressed() -> void:
	if slot_data:
		if slot_data.item_data:
			if slot_data.item_data.use() == false:
				return
			slot_data.quantity -= 1
			label.text = str(slot_data.quantity)
			if slot_data.quantity>0: #onpress不会触发pausemenu的刷新，所有使用道具后仍然维持焦点。
				await get_tree().process_frame
				self.grab_focus()
	
				
	pass # Replace with function body.

@tool
class_name TreasureCHest extends Node2D

@export var item_data : ItemData : set = _set_item_data
@export var quantity : int =1 : set = _set_quantity

var is_open : bool = false
@onready var sprite: Sprite2D = $ItemSprite2D
@onready var label: Label = $ItemSprite2D/Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interact_area : Area2D = $Area2D
@onready var is_open_data: PersistemDataHandler = $IsOpen


func _ready() -> void:
	_updat_texture()
	_updat_label()
	#sprite.visible = false
	if Engine.is_editor_hint():
		return
	is_open_data.data_loaded.connect(set_chest_state)
	set_chest_state()
	pass

func set_chest_state()->void:
	is_open = is_open_data.value
	if is_open:
		animation_player.play("opened")
	else:
		animation_player.play("closed")
	

func player_interact()->void:
	if is_open == true:
		return
	is_open = true
	is_open_data.set_value()
	if item_data == null or quantity == 0: #空箱子策略
		animation_player.play("opened")
		return
	animation_player.play("open_chest")
	if item_data and quantity > 0:
		PlayerManager.INVENTORY_DATA.add_item(item_data,quantity)
	else:
		printerr("No items in chest")
		push_error("No items in chest! Chest name",name)
	
	pass

func _on_interact_area_entered(area: Area2D) -> void:
	PlayerManager.interact_pressed.connect(player_interact)
	pass # Replace with function body.

func _on_interact_area_exited(area: Area2D) -> void:
	PlayerManager.interact_pressed.disconnect(player_interact)
	pass # Replace with function body.

func _set_item_data( value : ItemData )->void:
	item_data = value
	_updat_texture()
	pass
	
func _set_quantity( value : int )->void:
	quantity = value
	_updat_label()
	pass
	
func _updat_texture()->void:
	if item_data and sprite:
		sprite.texture = item_data.texture
		
func _updat_label()->void:
	if label:
		if quantity<=1:
			label.text = ""
		else:
			label.text = "x"+str(quantity)

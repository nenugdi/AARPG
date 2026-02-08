@tool
class_name ItemDropper extends Node2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var has_droppedd_data: PersistemDataHandler = $PersistemDataHandler
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var has_dropped : bool = false

const PICKUP = preload("res://Items/item_pickup/item_pickup.tscn")

@export var item_data : ItemData : set = _set_item_data

func _ready() -> void:
	if Engine.is_editor_hint()==true:
		_update_texture()
		return
	sprite.visible = false
	has_droppedd_data.data_loaded.connect(_on_data_loaded)
	_on_data_loaded()

func drop_item():
	if has_dropped:
		return
	has_dropped=true
	var drop = PICKUP.instantiate() as ItemPickup
	drop.item_data = item_data
	add_child(drop)
	drop.picked_up.connect(_on_drop_pickup)
	audio_stream_player.play()

func _on_drop_pickup():
	has_droppedd_data.set_value()

func _set_item_data(value:ItemData):
	item_data = value
	_update_texture()
	
	
func _update_texture():
	if Engine.is_editor_hint()==true:
		if item_data and sprite:
			sprite.texture = item_data.texture
			
			
func _on_data_loaded():
	has_dropped = has_droppedd_data.value
	
			

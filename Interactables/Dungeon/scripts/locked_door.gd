class_name LockedDoor extends Node2D

var is_open : bool = false

@export var key_item : ItemData #开门所需物品类型

@export var locked_audio : AudioStream
@export var open_audio : AudioStream

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var is_open_data : PersistemDataHandler = $PersistemDataHandler
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D 
@onready var interact_area_2d: Area2D = $InteractArea2D


func _ready() -> void:
	#is_open_data.data_loaded.connect( set_state ) #不清楚连接这个信号作用，set_state()处理门的开关状态 is_open_data
	set_state()
	pass
	

func _on_interact_area_2d_area_entered(area: Area2D) -> void:
	PlayerManager.interact_pressed.connect( open_door )
	pass # Replace with function body.


func _on_interact_area_2d_area_exited(area: Area2D) -> void:
	PlayerManager.interact_pressed.disconnect( open_door )
	pass # Replace with function body.

func open_door():
	if key_item == null:
		return
	var door_unlocked = PlayerManager.INVENTORY_DATA.use_item(key_item)
	
	if door_unlocked:
		animation_player.play("open_door")
		audio_stream_player_2d.stream = open_audio
		is_open_data.set_value() #把开门信息保存到存档文件的persistence中
	else:
		audio_stream_player_2d.stream = locked_audio
	audio_stream_player_2d.play()
	pass

func close_door():
	animation_player.play("close_door")
	
func set_state():
	is_open =is_open_data.value
	if is_open:
		animation_player.play("opened")
	else:
		animation_player.play("closed")

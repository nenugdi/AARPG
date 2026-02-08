class_name PressurePlate extends Node

signal activated
signal deactivated

var bodies : int = 0
var is_active : bool = false
var off_rect : Rect2 #矩形，包括2个Vector，position和size

@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
#这是在脚本中预加载音频资源
#音频资源在场景加载时就被加载到内存
#通过代码变量引用，不直接与场景节点绑定
#需要配合AudioStreamPlayer或AudioStreamPlayer2D节点来播放
#使用场景：
#需要在运行时动态切换不同音频
#音频资源较多，想按需管理
#音频逻辑与节点分离
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var audio_active : AudioStream = preload("res://Interactables/Dungeon/lever-01.wav")
@onready var audio_deactive : AudioStream = preload("res://Interactables/Dungeon/lever-02.wav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	off_rect = sprite_2d.region_rect #获取按压板的矩形框数据
	pass # Replace with function body.

func _on_area_2d_body_entered(body: Node2D) -> void:
	bodies += 1
	check_is_activated()
	pass # Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
	bodies -= 1
	check_is_activated()
	pass # Replace with function body.

func check_is_activated()->void:
	if bodies>0 and is_active == false:
		is_active = true
		sprite_2d.region_rect.position.x = off_rect.position.x - 32 #在图集中 x-32坐标是压力板按压后状态
		play_audio(audio_active)
		activated.emit()
	elif bodies<=0 and is_active == true:
		is_active = false
		sprite_2d.region_rect.position.x = off_rect.position.x
		play_audio(audio_deactive)
		deactivated.emit()

func play_audio(_steam : AudioStream)->void:
	audio_stream_player_2d.stream = _steam
	audio_stream_player_2d.play()

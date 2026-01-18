@tool
class_name ItemPickup extends CharacterBody2D

@export var item_data : ItemData : set = _set_item_data

@onready var area_2d: Area2D = $Area2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready()->void:
	_update_texture()
	if Engine.is_editor_hint():
		return
	#area_2d.body_entered.connect(_on_area_2d_area_entered)
		
func _physics_process(delta: float) -> void:
	if get_slide_collision_count() > 0:
		var collision_info = get_slide_collision(0)
		var normal = collision_info.get_normal()
		#print("碰撞次数: ", get_slide_collision_count())
		#完美弹性碰撞
		velocity = velocity.bounce(normal)
	velocity = velocity * 0.9
	move_and_slide()

	
	
	
func _on_body_entered()->void:
	pass

#此处并没有按教程处理，直接检查器的body_entered(body: Node2D)信号连接函数
func _on_area_2d_body_entered(b) -> void:
	if b is Player:
		if item_data:
			if PlayerManager.INVENTORY_DATA.add_item(item_data) == true:
				item_picked_up()
	pass 

func item_picked_up()->void:
	#area_2d.body_entered.disconnect(_on_area_2d_area_entered) #主动断开连接，防止重复拾取
	audio_stream_player_2d.play()
	self.visible = false #不然要等到音效结束才消失
	await audio_stream_player_2d.finished
	queue_free()
	pass



func _set_item_data(value : ItemData)->void:
	item_data = value
	_update_texture()

func _update_texture()->void:
	if item_data and sprite_2d:
		sprite_2d.texture = item_data.texture
	pass

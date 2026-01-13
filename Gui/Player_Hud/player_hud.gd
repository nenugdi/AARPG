extends CanvasLayer

var hearts : Array[HeartGui] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for c in $Control/HFlowContainer.get_children():
		if c  is HeartGui:
			hearts.append(c)
			c.visible = false
	pass # Replace with function body.


func update_hp( _hp:int, _max_hp:int)->void:# maxhp最多有多少个血量，两点血对应一颗红心
	update_max_hp(_max_hp)
	for i in _max_hp:
		update_heart( i, _hp)
	pass
	
func update_heart( _index : int, _hp : int )->void: #index哪个红心，hp是具体值
	var _value : int = clampi( _hp - _index*2, 0, 2) # 对于index来说，如果hp减去index*2，大于2，这个index红心是满血。
	hearts[ _index ].value = _value  #用对应红心的对应帧
	pass
	
func update_max_hp( _max_hp : int )->void:
	var _heart_count = roundi( _max_hp*0.5 )
	for i in hearts.size():
		if i < _heart_count:
			hearts[ i ].visible = true
		else:
			hearts[ i ].visible = false
	pass

class_name VisionArea extends Area2D

signal  player_entered()
signal  player_exited()

@onready var polygon_2d: Polygon2D = $Polygon2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	draw_Polygon()
	var p = get_parent()
	if p is Enemy:
		p.direction_changed.connect(_on_direction_change)
	pass # Replace with function body.


func _on_body_entered(_b: Node2D) -> void:
	if _b is Player:
		player_entered.emit()
	pass # Replace with function body.


func _on_body_exited(_b: Node2D) -> void:
	if _b is Player:
		player_exited.emit()
	pass # Replace with function body.

func _on_direction_change( new_direction:Vector2 )->void:
	match new_direction:
		Vector2.DOWN:
			rotation_degrees = 0
		Vector2.UP:
			rotation_degrees = 180
		Vector2.LEFT:
			rotation_degrees = 90
		Vector2.RIGHT:
			rotation_degrees = -90
		_:
			rotation_degrees = 0
	
func draw_Polygon()->void:
	polygon_2d.polygon = $CollisionPolygon2D.polygon
	polygon_2d.color = Color(0.7, 0.189, 0.189, 0.49)  # 红色半透明
	polygon_2d.z_index = 100
	add_child(polygon_2d)
	# 设置所有子节点为可编辑（方便调试）
	polygon_2d.owner = self

class_name BarredDoor extends Node2D

var is_open : bool = false
@onready var animation_player: AnimationPlayer = $StaticBody2D/AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

#在D01地图中，将PressurePlate的两个信号绑定到open_door  close_door
func open_door()->void:
	animation_player.play("open_door")
	
	
func close_door():
	animation_player.play("close_door")

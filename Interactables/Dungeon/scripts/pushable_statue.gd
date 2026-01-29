class_name  PushableStatue extends RigidBody2D

@export var push_speed : float =30.0

var push_direction : Vector2 = Vector2.ZERO : set = _set_push #set作用是当push_direction的值变化时执行函数

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func _physics_process(delta: float) -> void:
	linear_velocity = push_direction * push_speed
	
	

func _set_push( value : Vector2):
	push_direction = value
	print(push_direction)
	if push_direction == Vector2.ZERO:
		audio_stream_player_2d.stop()
	else:
		audio_stream_player_2d.play()

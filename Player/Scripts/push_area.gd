extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

#检测到body（雕像）
func _on_body_entered(body: Node2D) -> void:
	if body is PushableStatue:
		body.push_direction = PlayerManager.player.direction
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	if body is PushableStatue:
		body.push_direction = Vector2.ZERO
	pass # Replace with function body.

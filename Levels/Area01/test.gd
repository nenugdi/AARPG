extends Node2D

func _ready():
	print("=== 调试测试场景 ===")

	# 创建按钮
	var button = Button.new()
	button.text = "调试按钮"
	button.position = Vector2(100, 100)
	button.size = Vector2(200, 60)
	button.pressed.connect(_on_debug_button_pressed)
	add_child(button)

	# 创建玩家节点用于测试
	var player = Sprite2D.new()
	player.name = "DebugPlayer"
	player.position = Vector2(300, 300)
	player.texture = preload("res://icon.svg")  # 使用Godot默认图标
	add_child(player)

	print("调试按钮和玩家已创建")

func _on_debug_button_pressed():
	print("✓ 调试按钮被点击！")

	# 旋转玩家
	var player = get_node_or_null("DebugPlayer")
	if player:
		player.rotation_degrees += 90
		print("玩家旋转到: ", player.rotation_degrees, "度")
	else:
		print("错误：找不到调试玩家")

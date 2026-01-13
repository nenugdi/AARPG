class_name PlayerCamera extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#LevelManager 是在项目中使用GolbalLevelManager脚本创建的全局实例
	#此处目的是链接TileMapBoundsChanged信号，获取地图大小，同时改变相机范围
	LevelManager.TileMapBoundsChanged.connect(UpdateLimits) 
	UpdateLimits(LevelManager.current_tilemap_bounds) #此功能在多关卡时使用
	pass # Replace with function body.


func UpdateLimits( bounds : Array[Vector2])->void:
	if bounds == []:
		return
	limit_left = int(bounds[0].x)
	limit_right = int(bounds[1].x)
	limit_top = int(bounds[0].y)
	limit_bottom = int(bounds[1].y) #错写成X，难怪摄像机范围很怪异

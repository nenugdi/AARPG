class_name LevelTileMap extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#全局类LevelManager，调用函数，把地图自己的矩形大小传递出去，同时LevelManager的ChangeTilemapBounds函数发射信号
	LevelManager.ChangeTilemapBounds(GetTilemapBounds())
	pass # Replace with function body.

func GetTilemapBounds()->Array[Vector2]:
	var bounds : Array[Vector2] = []
	bounds.append( Vector2(get_used_rect().position * rendering_quadrant_size))
	bounds.append( Vector2(get_used_rect().end * rendering_quadrant_size))
	return bounds

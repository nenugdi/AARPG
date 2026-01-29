class_name Level extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.y_sort_enabled = true
	#目的是把自己场景作为玩家父节点，玩家实例是全局且唯一，这样把能把玩家挂在地图，起始位置由前一场景决定，或者PlayerSpawn决定
	PlayerManager.set_as_playerparent(self) 
	LevelManager.level_load_started.connect( _free_level )

func _free_level()->void:
	PlayerManager.unparent_player(self)
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

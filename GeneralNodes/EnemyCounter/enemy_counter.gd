class_name EnemyCount extends Node2D

signal enemyies_defeated


func  _ready() -> void:
	child_exiting_tree.connect(_on_enemy_destroyed)
	pass
	
	
func _on_enemy_destroyed( e : Node2D ):
	if e is Enemy:
		if enemy_count()<=1:
			enemyies_defeated.emit()
	pass
	
	
func enemy_count() -> int:
	var _count :int =0
	for c in get_children():
		if c is Enemy:
			_count +=1
	return _count

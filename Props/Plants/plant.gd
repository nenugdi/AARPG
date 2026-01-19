class_name Plant extends Node2D
const PICKUP = preload("res://Items/item_pickup/item_pickup.tscn")
@onready var hit_box: HitBox = $HitBox
@export var drops : Array[DropData]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hit_box.Damaged.connect( TakeDamage )
	pass # Replace with function body.


func TakeDamage( hurt_box : HurtBox )->void:
	drop_items()
	queue_free()
	

#给植物添加物品掉落功能
func drop_items()->void:
	if drops.size()==0:
		return
	for i in drops.size():
		if drops[i]==null or drops[i].item == null:
			continue
		var drop_count : int = drops[i].get_drop_count()
		for j in drop_count:
			var drop : ItemPickup = PICKUP.instantiate() as ItemPickup
			drop.item_data = drops[i].item
			self.get_parent().add_child(drop)
			drop.global_position = self.global_position+Vector2(randf_range(0,10),randf_range(0,10))
			drop.velocity = Vector2(randf_range(0,250),randf_range(0,250))

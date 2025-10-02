class_name ItemInstance
extends Area3D

@export var item_gravity: float= 10.0
@export var item_damping: float= 0.1
@export var bounce_height: float= 0.2
@export var bounce_duration: float= 0.5


@onready var ray_cast: RayCast3D = $RayCast3D
@onready var sprite: Sprite3D = $Sprite3D

var velocity: Vector3
var inv_item: InventoryItem:
	set(i):
		inv_item= i
		assert(inv_item)
		sprite.texture= inv_item.item_type.inventory_icon



func _physics_process(delta: float) -> void:
	if ray_cast.is_colliding():
		freeze()
		return
	
	velocity.y+= -item_gravity * delta
	velocity*= 1 - item_damping * delta
	position+= velocity * delta


func freeze():
	set_physics_process(false)
	var tween:= create_tween()
	
	tween.tween_property(sprite, "position:y", bounce_height, bounce_duration)
	tween.tween_property(sprite, "position:y", 0, bounce_duration)
	tween.set_loops()


func pick_up()-> InventoryItem:
	queue_free()
	return inv_item

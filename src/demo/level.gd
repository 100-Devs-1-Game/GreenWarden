class_name Level
extends Node3D

@export var crop_plot_scene: PackedScene
@export var item_instance_scene: PackedScene

var structures: Dictionary



func _ready() -> void:
	Global.level= self


func build_structure(structure_type: StructureType, tile: Vector2i):
	if structures.has(tile):
		return
	
	var structure: Structure= structure_type.scene.instantiate()
	structure.type= structure_type
	structure.position= get_pos_from_tile(tile)
	structures[tile]= structure
	add_child(structure)


func spawn_item(inv_item: InventoryItem, pos: Vector3):
	assert(inv_item)
	var item_inst: ItemInstance= item_instance_scene.instantiate()
	item_inst.position= pos
	add_child(item_inst)
	item_inst.inv_item= inv_item


func snap_floor_tile_pos(pos: Vector3)-> Vector3:
	pos.y= 0
	pos= pos.floor()
	return pos + Vector3(0.5, 0.0, 0.5)


func get_tile(pos: Vector3)-> Vector2i:
	return Vector2i(floor(pos.x), floor(pos.z))


func get_pos_from_tile(tile: Vector2i)-> Vector3:
	return snap_floor_tile_pos(Vector3(tile.x, 0, tile.y))


func is_tile_empty(tile: Vector2i)-> bool:
	return not structures.has(tile)

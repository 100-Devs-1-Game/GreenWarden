class_name DemoLevel
extends Node3D

@export var crop_plot_scene: PackedScene
@export var item_instance_scene: PackedScene

var crop_plots: Dictionary


func create_crop_plot(pos: Vector3):
	pos= snap_floor_tile_pos(pos)
	var tile: Vector2i= get_tile(pos)
	if crop_plots.has(tile):
		return
	
	var crop_plot: CropPlot= crop_plot_scene.instantiate()
	crop_plot.position= pos
	crop_plots[tile]= crop_plot
	add_child(crop_plot)


func snap_floor_tile_pos(pos: Vector3)-> Vector3:
	pos.y= 0
	pos= pos.floor()
	return pos + Vector3(0.5, 0.0, 0.5)


func spawn_item(inv_item: InventoryItem, pos: Vector3):
	assert(inv_item)
	var item_inst: ItemInstance= item_instance_scene.instantiate()
	item_inst.position= pos
	add_child(item_inst)
	item_inst.inv_item= inv_item


func get_tile(pos: Vector3)-> Vector2i:
	return Vector2i(floor(pos.x), floor(pos.z))

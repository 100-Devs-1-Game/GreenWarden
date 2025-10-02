class_name CropPlot
extends Area3D

var plant: PlantObject


func plant_seed(seed: SeedItem):
	assert(plant == null)
	var plant_type: PlantType= seed.plant
	plant= plant_type.plant_scene.instantiate()
	plant.type= plant_type
	add_child(plant)


func harvest()-> InventoryItem:
	var item: Item= plant.type.harvest_item
	var amount:= randi_range(plant.type.harvest_min, plant.type.harvest_max)
	var inv_item:= InventoryItem.new(item, amount)
	plant.queue_free()
	plant= null
	return inv_item


func can_harvest()-> bool:
	if not plant:
		return false
	return plant.grow_stage == plant.type.num_growth_stages - 1

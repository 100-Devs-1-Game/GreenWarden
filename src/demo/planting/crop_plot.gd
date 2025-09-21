class_name CropPlot
extends Area3D

var plant: PlantObject


func plant_seed(seed: SeedItem):
	assert(plant == null)
	var plant_type: PlantType= seed.plant
	plant= plant_type.plant_scene.instantiate()
	plant.type= plant_type
	add_child(plant)


func harvest()-> Item:
	var item: Item= plant.type.harvest_item
	plant.queue_free()
	plant= null
	return item


func can_harvest()-> bool:
	if not plant:
		return false
	return plant.grow_stage == plant.type.num_growth_stages - 1

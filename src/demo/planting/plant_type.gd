class_name PlantType
extends Resource

@export var plant_scene: PackedScene

@export var num_growth_stages: int= 3
@export var growth_time_per_stage: float= 10.0
@export var harvest_item: Item
@export var harvest_min: int= 1
@export var harvest_max: int= 2

class_name TerrainGenerator
extends Node

@export var noise: FastNoiseLite
@export var min_radius: int= 30
@export var max_radius: int= 60
@export var max_height: int= 5
@export var max_blocks: int= 20000

@onready var multi_mesh_instance: MultiMeshInstance3D = $MultiMeshInstance3D



func _ready() -> void:
	generate()


func generate():
	multi_mesh_instance.multimesh.instance_count= max_blocks
	
	var ctr:= 0
	for x in range(-max_radius, max_radius + 1):
		for y in range(-max_radius, max_radius + 1):
			var pos:= Vector2(x, y)
			if pos.length() < min_radius:
				continue
			var height= noise.get_noise_2dv(pos) + 1
			height*= remap(pos.length(), min_radius, max_radius, 1, max_height)
			for block_height in int(height):
				var trans:= Transform3D(Basis.IDENTITY, Vector3(pos.x, block_height + 1, pos.y) - Vector3.ONE / 2.0)
				multi_mesh_instance.multimesh.set_instance_transform(ctr, trans)
				ctr+= 1
	
	prints(ctr, "blocks generated")
	multi_mesh_instance.multimesh.visible_instance_count= ctr
			
		

class_name Structure
extends StaticBody3D

var type: StructureType



func _ready() -> void:
	if type.blocks_path:
		Global.pathfinder.register_structure(self)

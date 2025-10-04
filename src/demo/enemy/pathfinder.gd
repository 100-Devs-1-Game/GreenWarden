class_name Pathfinder
extends Node

@export var area: Rect2i

@onready var level: Level= get_parent()

var astar:= AStarGrid2D.new()


func _ready() -> void:
	Global.pathfinder= self

	astar.region= area
	astar.update()


func calculate_path(from: Vector3, to: Vector3)-> PackedVector3Array:
	var from_tile: Vector2i= level.get_tile(from)
	var to_tile: Vector2i= level.get_tile(to)
	var path: PackedVector2Array= astar.get_point_path(from_tile, to_tile)
	var result: PackedVector3Array
	for point in path:
		result.append(Vector3(point.x, 0, point.y))
	return result
		

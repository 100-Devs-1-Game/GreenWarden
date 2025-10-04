class_name Enemy
extends RigidBody3D

@export var move_speed: float= 4.0

@onready var head: MeshInstance3D = %Head

var path: PackedVector3Array



func _physics_process(delta: float) -> void:
	if path.size() < 2:
		return
	
	var target_pos:= path[1]
	if arrived_at(target_pos):
		path.remove_at(0)
		if path.size() < 2:
			return
		target_pos= path[1]
		
		
	linear_velocity= position.direction_to(target_pos) * move_speed

	var look_target:= position + linear_velocity.normalized()
	look_target.y= head.global_position.y
	if not head.global_position.is_equal_approx(look_target):
		head.look_at(look_target)


func arrived_at(target: Vector3)-> bool:
	return Vector2(position.x, position.z).distance_to(Vector2(target.x, target.z)) < 11


func _on_timer_pathfinder_update_timeout() -> void:
	if not Global.player:
		return
	
	path= Global.pathfinder.calculate_path(position, Global.player.position)

class_name Enemy
extends RigidBody3D

@export var move_speed: float= 4.0

@onready var head: MeshInstance3D = %Head

var target_pos: Vector3


func _ready() -> void:
	target_pos= position


func _physics_process(delta: float) -> void:
	linear_velocity= position.direction_to(target_pos) * move_speed

	var look_target:= position + linear_velocity.normalized()
	look_target.y= head.global_position.y
	if not head.global_position.is_equal_approx(look_target):
		head.look_at(look_target)
	

func _on_timer_pathfinder_update_timeout() -> void:
	if not DemoGlobal.player:
		return
	
	var path: PackedVector3Array= DemoGlobal.pathfinder.calculate_path(position, DemoGlobal.player.position)
	if path.size() > 2 :
		target_pos= path[2]

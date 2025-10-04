class_name Enemy
extends RigidBody3D

@export var move_speed: float= 4.0

@onready var model: Node3D = $Model
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var blood_particles: CPUParticles3D = $"CPUParticles3D Blood"

var path: PackedVector3Array
var knockback: Vector3


func _ready() -> void:
	animation_player.play("walk")


func _physics_process(delta: float) -> void:
	if path.size() < 2:
		return
	
	var target_pos:= path[1]
	#if arrived_at(target_pos):
		#path.remove_at(0)
		#if path.size() < 2:
			#return
		#target_pos= path[0]
		#prints("New target pos", target_pos)
		
	var walk_velocity:= position.direction_to(target_pos) * move_speed

	var look_target:= position + walk_velocity.normalized()
	look_target.y= model.global_position.y
	if not model.global_position.is_equal_approx(look_target):
		model.look_at(look_target)

	linear_velocity= walk_velocity + knockback
	knockback= knockback.lerp(Vector3.ZERO, delta)


func arrived_at(target: Vector3)-> bool:
	return Vector2(position.x, position.z).distance_to(Vector2(target.x, target.z)) < 11


func hurt(from: Vector3):
	var dir:= from.direction_to(position)
	knockback= dir * 5
	blood_particles.emitting= true
	

func _on_timer_pathfinder_update_timeout() -> void:
	if not Global.player:
		return
	
	path= Global.pathfinder.calculate_path(position, Global.player.position)

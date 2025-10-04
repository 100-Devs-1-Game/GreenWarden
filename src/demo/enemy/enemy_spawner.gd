extends Node3D

@export var enemy_scene: PackedScene



func _ready() -> void:
	assert(enemy_scene)


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_pressed():
		return
	
	if event.is_action("spawn_enemy"):
		var enemy: Enemy= enemy_scene.instantiate()
		enemy.position= global_position
		Global.level.add_child(enemy)
		

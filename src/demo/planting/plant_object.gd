class_name PlantObject
extends Node3D

var type: PlantType
var grow_stage: int= 0
var timer:= Timer.new()


func _ready() -> void:
	assert(type != null)
	
	timer.wait_time= type.growth_time_per_stage
	timer.autostart= true
	timer.one_shot= false
	timer.timeout.connect(_on_grow)
	add_child(timer)


func _on_grow():
	(get_child(grow_stage) as Node3D).hide()
	grow_stage+= 1
	(get_child(grow_stage) as Node3D).show()

	if grow_stage == type.num_growth_stages - 1:
		timer.queue_free()

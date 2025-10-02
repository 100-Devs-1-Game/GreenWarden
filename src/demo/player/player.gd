class_name Player
extends CharacterBody3D

@export var level: DemoLevel
@export var move_speed: float= 5.0
@export var mouse_sensitivity: float= 0.2
@export var seed_item: SeedItem
@export var structure: StructureType

@onready var camera_pivot: Node3D = $CameraPivot
@onready var camera: Camera3D = $CameraPivot/Camera3D
@onready var ray_cast: RayCast3D = %RayCast3D
@onready var hotbar: Hotbar = %Hotbar

@onready var label_feedback: Label = %"Label Feedback"



func _ready() -> void:
	DemoGlobal.player= self
	
	Input.mouse_mode= Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	var move_dir: = Input.get_vector("strafe_left", "strafe_right", "move_forward", "move_back")
	var forward: Vector3 = camera.global_transform.basis * Vector3(move_dir.x, 0, move_dir.y)
	var walk_dir: Vector3 = Vector3(forward.x, 0, forward.z).normalized()
	velocity= walk_dir * move_speed
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camera.rotate_x(deg_to_rad(-event.relative.y) * mouse_sensitivity)
		camera_pivot.rotate_y(deg_to_rad(-event.relative.x) * mouse_sensitivity)
	
	elif event is InputEventMouseButton:
		if event.pressed:
			if ray_cast.is_colliding():
				var target_obj: Node3D= ray_cast.get_collider()
				
				if target_obj is CropPlot:
					var crop_plot: CropPlot= target_obj
					if crop_plot.plant != null:
						if crop_plot.can_harvest():
							level.spawn_item(crop_plot.harvest(), crop_plot.position + Vector3.UP)
					else:
						crop_plot.plant_seed(seed_item)
				else:
					level.create_crop_plot(ray_cast.get_collision_point())


func pick_up_item(item_inst: ItemInstance):
	var inv_item:= item_inst.pick_up()
	hotbar.add_item(inv_item)
	show_feedback("Picked up " + inv_item.item_type.display_name)
	

func show_feedback(text: String):
	label_feedback.text= text


func _on_pickup_area_area_entered(area: Area3D) -> void:
	var item_inst: ItemInstance= area
	assert(item_inst)
	if can_pick_up(item_inst):
		pick_up_item(item_inst)


func can_pick_up(item_inst: ItemInstance)-> bool:
	#TODO check for empty/matching slot in Hotbar Inventory
	return true

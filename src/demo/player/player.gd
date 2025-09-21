class_name Player
extends CharacterBody3D

@export var level: DemoLevel
@export var mouse_sensitivity: float= 0.2
@export var seed_item: SeedItem

@onready var camera_pivot: Node3D = $CameraPivot
@onready var camera: Camera3D = $CameraPivot/Camera3D
@onready var ray_cast: RayCast3D = %RayCast3D

@onready var label_feedback: Label = %"Label Feedback"



func _ready() -> void:
	DemoGlobal.player= self
	
	Input.mouse_mode= Input.MOUSE_MODE_CAPTURED


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
							pickup_item(crop_plot.harvest())
					else:
						crop_plot.plant_seed(seed_item)
				else:
					level.create_crop_plot(ray_cast.get_collision_point())


func pickup_item(item: Item):
	label_feedback.text= "Picked up " + item.display_name

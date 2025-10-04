extends HandObject

@export var crop_plot_structure: StructureType



func use(primary_action: bool, player: Player):
	super(primary_action, player)
	
	var ray_cast: RayCast3D= player.ray_cast
	if ray_cast.is_colliding():
		var target_obj: Node3D= ray_cast.get_collider()
		
		if target_obj.collision_layer == CollisionLayers.TERRAIN:
			var level: Level= Global.level
			var tile: Vector2i= level.get_tile(ray_cast.get_collision_point())
			if level.is_tile_empty(tile):
				level.build_structure(crop_plot_structure ,tile)

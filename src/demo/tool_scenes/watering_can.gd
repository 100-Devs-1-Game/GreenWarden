extends HandObject



func use(primary_action: bool, player: Player):
	super(primary_action, player)
	
	var ray_cast:= player.ray_cast
	if ray_cast.is_colliding():
		var target_obj: Node3D= ray_cast.get_collider()
		if target_obj: 
			if target_obj is Barrel and not primary_action:
				refill()
			elif target_obj is CropPlot and primary_action:
				water(target_obj)


func refill():
	ItemDataFillRatio.set_data(inv_item.data, 1.0)


func water(crop_plot: CropPlot):
	var water_ratio: float= ItemDataFillRatio.parse_data(inv_item.data)
	if water_ratio > 0:
		water_ratio-= 0.1
		ItemDataFillRatio.set_data(inv_item.data, water_ratio)
		crop_plot.water()

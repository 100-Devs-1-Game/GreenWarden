class_name HandObject
extends Node3D

var inv_item: InventoryItem



func use(primary_action: bool, player: Player):
	var item_type: Item= inv_item.item_type 
	var has_action: bool= item_type.has_primary_action if primary_action else item_type.has_secondary_action
	var anim: String= item_type.primary_action_anim if primary_action else item_type.secondary_action_anim

	if not has_action:
			return
	if anim:
		player.animation_player_hand.play(anim)

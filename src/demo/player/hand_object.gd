class_name HandObject
extends Node3D

var type: HandItem



func use(primary_action: bool, player: Player):
	var has_action: bool= type.has_primary_action if primary_action else type.has_secondary_action
	var anim: String= type.primary_action_anim if primary_action else type.secondary_action_anim

	if not has_action:
			return
	if anim:
		player.animation_player_hand.play(anim) 
	

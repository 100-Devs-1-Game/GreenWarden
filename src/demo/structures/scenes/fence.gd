extends Structure

@onready var post: MeshInstance3D = %"MeshInstance3D Post"
@onready var x_fence: MeshInstance3D = %"MeshInstance3D X Fence"
@onready var z_fence: MeshInstance3D = %"MeshInstance3D Z Fence"



func on_placed():
	var player: Player= Global.player
	var player_dir:= -player.camera.global_basis.z
	if abs(player_dir.dot(Vector3.RIGHT)) > abs(player_dir.dot(Vector3.FORWARD)):
		z_fence.show()
	else:
		x_fence.show()

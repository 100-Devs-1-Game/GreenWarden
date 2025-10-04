extends Structure



func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Enemy:
		var enemy: Enemy= body
		enemy.hurt(position)

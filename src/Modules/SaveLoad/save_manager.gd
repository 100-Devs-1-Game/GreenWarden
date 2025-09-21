extends Node
class_name SaveManager

func save_value(
		save_path: String, 
		key: String, 
		value: Variant
) -> void:
	var file: FileAccess
	var save_data: Dictionary = {}
	if FileAccess.file_exists(save_path):
		file = FileAccess.open(save_path, FileAccess.READ)
		save_data = file.get_var()
		file.close()
	
	save_data[key] = value
	
	file = FileAccess.open(save_path, FileAccess.WRITE)
	var err: int = file.store_var(save_data)
	if err != OK:
		push_error("Failed to store the data to the file: %s" % err)
	file.close()


func load_value(
		save_path: String, 
		key: String, 
		default_value: Variant = null, 
		save_on_none: bool = false
) -> Variant:
	if not FileAccess.file_exists(save_path):
		if save_on_none:
			save_value(save_path, key, default_value)
		return default_value

	var file: FileAccess = FileAccess.open(save_path, FileAccess.READ)
	var save_data: Dictionary = file.get_var()
	file.close()

	return save_data.get(key, default_value)


func remove_key() -> void:
	pass


func remove_file() -> void:
	pass

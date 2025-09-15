func save_value(
		save_path: String, 
		key: String, 
		value: Array
):
	var file
	var save_data := {}
	if FileAccess.file_exists(save_path):
		file = FileAccess.open(save_path, FileAccess.READ)
		save_data = file.get_var()
		file.close()
	
	save_data[key] = value
	
	file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(save_data)
	file.close()


func load_value(
		save_path: String, 
		key: String, 
		default_value = null, 
		save_on_none := false
):
	if not FileAccess.file_exists(save_path):
		if save_on_none:
			save_value(save_path, key, default_value)
		return default_value

	var file = FileAccess.open(save_path, FileAccess.READ)
	var save_data = file.get_var()
	file.close()

	return save_data.get(key, default_value)


func remove_key():
	pass


func remove_file():
	pass

extends Control


func _on_play_pressed() -> void:
	var err: int = get_tree().change_scene_to_file("res://world.tscn") # placeholder
	if err != OK:
		print("failed to change to world scene: ", err)

func _on_settings_pressed() -> void:
	var err: int = get_tree().change_scene_to_file("res://UI Pages/settings.tscn")
	if err != OK:
		print("failed to change to settings scene: ", err)


func _on_credits_pressed() -> void:
	var err: int = get_tree().change_scene_to_file("res://UI Pages/credits.tscn")
	if err != OK:
		print("failed to change to credits scene: ", err)


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_discord_button_pressed() -> void:
	var err: int = OS.shell_open("https://discord.gg/UHN4AjMw4d")
	if err != OK:
		print("failed to open 'https://discord.gg/UHN4AjMw4d': ", err)

extends Control

#(get_stack()[0]["source"], " : ", get_stack()[0]["line"], " : ", get_stack()[0]["function"])

func _ready() -> void:
	pass
	
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://world.tscn") # placeholder

func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://UI Pages/Settings.tscn")

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://UI Pages/Credits.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_discord_button_pressed() -> void:
	OS.shell_open("https://discord.gg/UHN4AjMw4d")

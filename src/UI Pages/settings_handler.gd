extends Node

# TODO make settings savable
# TODO figure out final settings options

@onready var SaveLoad: Node = preload("res://Modules/SaveLoad/save_manager.gd").new()


func _ready() -> void:
	if not InputMap.has_action("menu_exit"):
		var key_pressed: InputEventKey = InputEventKey.new()
		key_pressed.physical_keycode = KEY_ESCAPE
		InputMap.add_action("menu_exit", 0.2)
		InputMap.action_add_event("menu_exit", key_pressed)
	
	for category: Node in get_node("SettingsMenu/HBoxContainer/SelectorPanel/Selector").get_children():
		if category.name == "Top":
			continue
		var err: int = (category as Button).pressed.connect(_on_category_pressed.bind(category))
		if err != OK:
			push_error("Failed to connect pressed signal: %s" % err)
	
	_on_category_pressed(get_node("SettingsMenu/HBoxContainer/SettingsSections/Controls"))


func _on_category_pressed(category: Node) -> void:
	if category.name == "SaveSettings":
		save_settings()
		
	if category.name == "ToTitle":
		var err: int = get_tree().change_scene_to_file("res://UI Pages/title_screen.tscn")
		if err != OK:
			push_error("failed to change to Title scene: %s" % err)
		
	var sections: Panel = get_node("SettingsMenu/HBoxContainer/SettingsSections")
	for section: HBoxContainer in sections.get_children():
		section.visible = true if category.name == section.name else false


func save_settings() -> void:
	pass


###Controls
##Core Essentials
#Invert Camera Pan – Flip camera movement horizontally.
#Camera Pan Speed – Adjust how fast the camera moves across the farm.
#Camera Zoom Speed – Change how quickly the camera zooms in/out.
##Optional / Polish
#Screen Shake – Enable or disable camera shake during action.
#Screen Flash Intensity – Adjust or disable bright flashes during combat.

###KeyMappings
##Core Essentials
#Movement Keys – Rebind walking or character movement.
#Interact Key – Rebind the key for interacting with crops, tools, or NPCs.
#Use Tool / Attack – Rebind primary tool use or attack action.
#Inventory Menu – Rebind the inventory toggle key.
##Optional / Polish
#Switch Tool / Item – Rebind cycling through inventory or hotbar.
#Pause / Settings – Rebind pause or settings menu key.

###Audio
##Core Essentials
#Master Volume – Adjust overall game volume.
#Music Volume – Adjust background music level.
#Effects Volume – Adjust sound effects (tools, attacks, enemies, weather).
##Optional / Polish
#Ambient Volume – Adjust environment sounds (wind, rain, night ambience).
#Dialogue Volume – Adjust NPC voices or text sound effects.
#Mute on Focus Loss – Mute the game when it’s not the active window.

###Video
##Core Essentials
#Resolution – Choose the game’s display resolution.
#Fullscreen / Windowed / Borderless – Select how the game window is displayed.
#Brightness / Gamma – Adjust how bright or dark the game looks.
#UI Scale – Change the size of menus and HUD elements.
##Optional / Polish
#VSync – Synchronize the frame rate with your monitor.
#Frame Rate Cap – Limit the maximum frames per second.
#FPS Counter – Show or hide the current frames per second.

###Graphics
##Core Essentials
#Lighting Quality – Adjust detail of torches, lamps, and night lighting effects.
#Shadow Quality – Set the sharpness and number of shadows, or turn them off.
#Particle Effects – Control the amount of dust, sparks, rain, and other effects.
#Outline Toggle – Enable outlines around crops and enemies for clarity at night.
##Optional / Polish
#Post-Processing – Toggle extras like bloom and color grading.
#Animation Smoothing – Smooth out character and object movement.
#Pixel Filter / Upscaling – Choose between sharp pixels or smoother scaling.
#Colorblind Mode – Apply alternate color palettes for better visibility.
#Weather Effects – Toggle rain, wind, and other environmental visuals.
#Environmental Detail Level – Adjust the number of props and small decorations.

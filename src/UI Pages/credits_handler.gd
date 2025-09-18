extends Node

# TODO figure out what groups credits should split into
# TODO figure out final credits to display

@onready var SaveLoad = preload("res://Modules/SaveLoad/save_manager.gd").new()


func _ready() -> void:
	if not InputMap.has_action("menu_exit"):
		var key_pressed = InputEventKey.new()
		key_pressed.physical_keycode = KEY_ESCAPE
		InputMap.add_action("menu_exit", 0.2)
		InputMap.action_add_event("menu_exit", key_pressed)
	
	var no_category = get_node("CreditsMenu/HBoxContainer/SelectorPanel/Selector/Top")
	for category in get_node("CreditsMenu/HBoxContainer/SelectorPanel/Selector").get_children():
		if category == no_category:
			continue
		category.pressed.connect(_on_category_pressed.bind(category.name))


func _on_category_pressed(category: String) -> void:
	if category == "ToTitle":
		get_tree().change_scene_to_file("res://UI Pages/title_screen.tscn")
	var sections = get_node("CreditsMenu/HBoxContainer/CreditsSections").get_children()
	for section in sections:
		section.visible = false
		if section.name == category:
			section.visible = true

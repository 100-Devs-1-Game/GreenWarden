extends Node

# TODO figure out what groups credits should split into
# TODO figure out final credits to display

func _ready() -> void:
	if not InputMap.has_action("menu_exit"):
		var key_pressed = InputEventKey.new()
		key_pressed.physical_keycode = KEY_ESCAPE
		InputMap.add_action("menu_exit", 0.2)
		InputMap.action_add_event("menu_exit", key_pressed)
	
	for category in get_node("CreditsMenu/HBoxContainer/SelectorPanel/Selector").get_children():
		if category.name == "Top":
			continue
		category.pressed.connect(_on_category_pressed.bind(category))
	
	# the default category or section 
	_on_category_pressed(get_node("CreditsMenu/HBoxContainer/CreditSections/OtherCredits"))


func _on_category_pressed(category: Node) -> void:
	if category.name == "ToTitle":
		get_tree().change_scene_to_file("res://UI Pages/title_screen.tscn")
		
	var sections = get_node("CreditsMenu/HBoxContainer/CreditSections")
	for section in sections.get_children():
		section.visible = true if category.name == section.name else false

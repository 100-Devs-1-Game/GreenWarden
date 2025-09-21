extends Node

# TODO figure out what groups credits should split into
# TODO figure out final credits to display

func _ready() -> void:
	if not InputMap.has_action("menu_exit"):
		var key_pressed: InputEventKey = InputEventKey.new()
		key_pressed.physical_keycode = KEY_ESCAPE
		InputMap.add_action("menu_exit", 0.2)
		InputMap.action_add_event("menu_exit", key_pressed)
	
	for category: Node in get_node("CreditsMenu/HBoxContainer/SelectorPanel/Selector").get_children():
		if category.name == "Top":
			continue
		var err: int = (category as Button).pressed.connect(_on_category_pressed.bind(category))
		if err != OK:
			push_error("Failed to connect pressed signal: %s" % err)
	
	# the default category or section 
	_on_category_pressed(get_node("CreditsMenu/HBoxContainer/CreditSections/OtherCredits"))


func _on_category_pressed(category: Node) -> void:
	if category.name == "ToTitle":
		var err: int = get_tree().change_scene_to_file("res://UI Pages/title_screen.tscn")
		if err != OK:
			push_error("failed to change to Title scene: %s" % err)

		
	var sections: Panel = get_node("CreditsMenu/HBoxContainer/CreditSections")
	for section: HBoxContainer in sections.get_children():
		section.visible = true if category.name == section.name else false

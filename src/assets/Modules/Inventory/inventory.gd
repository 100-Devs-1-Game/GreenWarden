extends Control

const INV_PATH = "InventoryContainer/HBoxContainer/VBoxContainer/Inventory"
const INVENTORY_SIZE := 30
const HOTBAR_SIZE := 6
const DEFAULT_SLOT := {
	"name": "",
	"description": "",
	"icon": "",
	"ammount": "",
	"catagory": "",
	"buyValue": "",
	"sellValue": "",
}

var inventory_contents := []
var hotbar_contents := []
var active_slot := 1
var labels := []

# INFORMARIONAL
# The "inventory" InputMap will be used by default for opening the inventory. 
# if not set, "inventory" defaults to KEY_E


func _ready() -> void:
	adjust_text_color()
	if !InputMap.has_action("inventory"):
		var key_E_pressed = InputEventKey.new()
		key_E_pressed.physical_keycode = KEY_E
		InputMap.add_action("inventory", 0.2)
		InputMap.action_add_event("inventory", key_E_pressed)
	
	for index in range(INVENTORY_SIZE):
		inventory_contents.append(DEFAULT_SLOT)
		
	for index in range(HOTBAR_SIZE):
		hotbar_contents.append(DEFAULT_SLOT)
	
	var index = -1
	for row in get_node("%s/Grid" % INV_PATH).get_children():
		print(row)
		if row == get_node("%s/Grid/HSeparator" % INV_PATH): 
			continue
		for slot in row.get_children():
			index += 1
			var button = slot.get_node("Interact")
			var item_count = slot.get_node("Count")
			button.focus_entered.connect(_on_button_pressed.bind(button, index))


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		toggle_invintory()


func calc_lum(c: float) -> float: 
	return (c / 12.92) if c <= 0.03928 else pow((c + 0.055) / 1.055, 2.4)


func get_contrast_color(background_color: Color) -> Color:
	var r = calc_lum(background_color.r)
	var g = calc_lum(background_color.g)
	var b = calc_lum(background_color.b)
	var lum = 0.2126 * r + 0.7152 * g + 0.0722 * b
	
	var contrast_white: float = 1.05 / (lum + 0.05)
	var contrast_black: float = (lum + 0.05) / 0.05
	if contrast_white > contrast_black:
		return Color.WHITE - background_color / 5
	else: 
		return Color.BLACK 


func adjust_text_color():
	labels.clear()
	var node = get_node("InventoryContainer")
	label_scan(node)
	
	var final = get_contrast_color(node.get_node("ColorRect").color)
	print(final)
	for label in labels:
		label.modulate = final


func label_scan(node: Node):
	if node is Label:
		labels.append(node)
	for child in node.get_children():
		label_scan(child)




func _on_button_pressed(button: Button, index: int) -> void:
	button.release_focus()
	print("button pressed: ", index, " - ", button)

func _on_exitInvintory_pressed():
	toggle_invintory()

func toggle_invintory() -> void:
	update_inventory_contents()
	if %InventoryContainer.visible:
		%InventoryContainer.hide()
		%HotbarContainer.show()
	else:
		%HotbarContainer.hide()
		%InventoryContainer.show()

func update_inventory_contents():
	pass

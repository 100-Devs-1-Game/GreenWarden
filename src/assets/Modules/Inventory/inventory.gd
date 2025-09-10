extends Control
const invPath = "InventoryContainer/HBoxContainer/VBoxContainer/Inventory"
var inventorySize = 30
var hotBarSize = 6
var activeSlot = 1
var hotbarContents = []
var inventoryContents = []
const defaultSlot = {
	"name": "",
	"description": "",
	"icon": "",
	"ammount": "",
	"catagory": "",
	"buyValue": "",
	"sellValue": ""
}

# INFORMARIONAL
# The "inventory" InputMap will be used by default for opening the inventory, if not set it defaults to KEY_E
#
#
#
#
#

func _ready() -> void:
	adjust_text_color()
	if !InputMap.has_action("inventory"):
		var key_E_pressed = InputEventKey.new()
		key_E_pressed.physical_keycode = KEY_E
		InputMap.add_action("inventory", 0.2)
		InputMap.action_add_event("inventory", key_E_pressed)
	
	for index in range(inventorySize):
		inventoryContents.append(defaultSlot)
	for index in range(hotBarSize):
		hotbarContents.append(defaultSlot)
	
	var index = -1
	for row in get_node("%s/grid" % invPath).get_children():
		if row == get_node("%s/grid/HSeparator" % invPath): continue
		for slot in row.get_children():
			index += 1
			var button = slot.get_node("interact")
			var itemCount = slot.get_node("count")
			button.focus_entered.connect(_on_button_pressed.bind(button, index))

var labels: Array = []

func calc_lum(c: float) -> float: return (c / 12.92) if c <= 0.03928 else pow((c + 0.055) / 1.055, 2.4)
func get_contrast_color(bgColor: Color) -> Color:
	var r = calc_lum(bgColor.r)
	var g = calc_lum(bgColor.g)
	var b = calc_lum(bgColor.b)
	var lum = 0.2126 * r + 0.7152 * g + 0.0722 * b

	var contrastW = 1.05 / (lum + 0.05)
	var contrastB = (lum + 0.05) / 0.05

	return (Color.WHITE if contrastW > contrastB else Color.BLACK) - bgColor / 5

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




func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		_Toggle_Invintory()

func _on_button_pressed(button: Button, index: int) -> void:
	button.release_focus()
	print("button pressed: ", index, " - ", button)

func _on_exitInvintory_pressed():
	_Toggle_Invintory()

func _Toggle_Invintory() -> void:
	if %InventoryContainer.visible:
		updateInventoryContents() 
		%InventoryContainer.hide()
		%HotbarContainer.show()
	else:
		updateInventoryContents()
		%HotbarContainer.hide()
		%InventoryContainer.show()

func updateInventoryContents():
	pass






var inventory: Array = []
var slot_limit = 30

func add_item(item):
	if inventory.size() >= slot_limit:
		push_warning("Inventory full, cannot add item.")
		return "full"
	inventory.append(item)
	return inventory.size()

func remove_item(item):
	if item in inventory:
		inventory.erase(item)
		return true
	else:
		push_warning("Item not found in inventory.")
		return false

func get_item(index: int):
	if index >= 0 and index < inventory.size():
		return inventory[index]
	else:
		push_warning("Index out of bounds in get_item.")
		return null

func get_inventory():
	return inventory
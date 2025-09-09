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

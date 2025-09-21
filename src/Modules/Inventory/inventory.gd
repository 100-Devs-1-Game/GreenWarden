extends Control

@warning_ignore("untyped_declaration")
@onready var SaveLoad = preload("res://Modules/SaveLoad/save_manager.gd").new()

const INVENTORY_FILE_PATH: String = "user://inventory.save"
const INV_PATH: String = "InventoryContainer/HBoxContainer/VBoxContainer/Inventory"
const INVENTORY_SIZE: int = 30
const HOTBAR_SIZE: int = 6
const DEFAULT_SLOT: Dictionary = {
	"name": "",
	"description": "",
	"icon": "",
	"category": "",
	"amount": 0.0,
	"buyValue": 0.0,
	"sellValue": 0.0,
}

var randslots: Array = [
	{
		"name": "Basic Hoe",
		"description": "Can be used to make soil farmable.",
		"icon": "res://Modules/Inventory/hoe.png",
		"category": "tool",
		"amount": 100.0,
		"buyValue": 70.0,
		"sellValue": 35.0,
	},{
		"name": "Wheat",
		"description": "Can be sold at the shop for currency or used in a recipe or during crafting.",
		"icon": "res://Modules/Inventory/wheat.png",
		"category": "crop",
		"amount": 1,
		"buyValue": 10.0,
		"sellValue": 8.0,
	},{
		"name": "Basic Watering Can",
		"description": "Can be used to speed up the growth of some crops.",
		"icon": "res://Modules/Inventory/watering_can.png",
		"category": "tool",
		"amount": 100.0,
		"buyValue": 50,
		"sellValue": 25,
	},{
		"name": "Mud Trap",
		"description": "When placed, it will passively slow enemies that wander across it with a low chance of stopping them completely.",
		"icon": "res://Modules/Inventory/trap.png",
		"category": "trap",
		"amount": 1,
		"buyValue": 75,
		"sellValue": 20,
	},
]

var inventory_contents: Array = []
var cursor_contents: Dictionary = {}
var active_slot: int = 0
var slots_queue: Array = []

# INFORMARIONAL
# The "inventory" InputMap will be used by default for opening the inventory. 
# if not set, "inventory" defaults to KEY_E

func _ready() -> void:
	adjust_text_color(0xfafafaff)
	if not InputMap.has_action("inventory"):
		var key_pressed: InputEventKey = InputEventKey.new()
		key_pressed.physical_keycode = KEY_E
		InputMap.add_action("inventory", 0.2)
		InputMap.action_add_event("inventory", key_pressed)
	
	for index: int in range(INVENTORY_SIZE):
		inventory_contents.append(DEFAULT_SLOT)
	
	var index: int = -1
	var no_row: HSeparator = get_node("%s/Grid/HSeparator" % INV_PATH)
	for row: HBoxContainer in get_node("%s/Grid" % INV_PATH).get_children():
		if row == no_row: 
			continue
		for slot: Panel in row.get_children():
			index += 1
			var button: Button = slot.get_node("Interact")
			var err: int = button.pressed.connect(_on_inventory_slot_pressed.bind(slot, index))
			if err != OK:
				push_error("Failed to connect pressed signal: %s" % err)
	
	index = -1
	var no_slot: HSeparator = get_node("HotbarContainer/Slots/Gap")
	for slot: Panel in get_node("HotbarContainer/Slots").get_children():
		if slot == no_slot:
			continue
		index += 1
		var button: Button = slot.get_node("Interact")
		var err: int = button.pressed.connect(_on_hotbar_slot_pressed.bind(slot, index))
		if err != OK:
			push_error("Failed to connect pressed signal: %s" % err)
	
	inventory_contents[randi_range(0,29)] = randslots[0]
	inventory_contents[randi_range(0,29)] = randslots[1]
	inventory_contents[randi_range(0,29)] = randslots[2]
	inventory_contents[randi_range(0,29)] = randslots[3]
	
	cursor_contents = DEFAULT_SLOT
	
	
	inventory_contents = SaveLoad.load_value(INVENTORY_FILE_PATH, "content", inventory_contents)
	refresh_visuals()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		toggle_invintory()


func _on_inventory_slot_pressed(button: Panel, index: int) -> void:
	if len(slots_queue) >= 2:
		slots_queue.clear()
	slots_queue.append(index)
	
	if len(slots_queue) == 2:
		swap_slot_to_slot(slots_queue)
	
	print("button pressed: ", index, " - ", button)


func _on_hotbar_slot_pressed(button: Panel, _index: int) -> void:
	var hotbar_slots: Array[Node] = get_node("HotbarContainer/Slots").get_children()
	var no_slot: Panel = get_node("HotbarContainer/Slots/Gap")
	for slot: Panel in hotbar_slots:
		if slot == no_slot:
			continue
		slot.get_node("Coloring").set("color", 0xffffff00)
	button.get_node("Coloring").set("color", 0xffffff2b)


func _on_exitInvintory_pressed() -> void:
	undo_cursor_grab()
	toggle_invintory()


## AUTO-CHANGE INVENTORY LABEL COLOR START
var labels: Array = []

func calc_lum(c: float) -> float: 
	return (c / 12.92) if c <= 0.03928 else pow((c + 0.055) / 1.055, 2.4)


func get_contrast_color(background_color: Color) -> Color:
	var r: float = calc_lum(background_color.r)
	var g: float = calc_lum(background_color.g)
	var b: float = calc_lum(background_color.b)
	var lum: float = 0.2126 * r + 0.7152 * g + 0.0722 * b
	
	var contrast_white: float = 1.05 / (lum + 0.05)
	var contrast_black: float = (lum + 0.05) / 0.05
	if contrast_white > contrast_black:
		return Color.WHITE - background_color / 5
	else: 
		return Color.BLACK 


func adjust_text_color(fixed: Color = 0x4A412Aff) -> void:
	var node: Panel = get_node("InventoryContainer")
	labels.clear()
	label_scan(node)
	
	var final: Color = get_contrast_color((node.get_node("ColorRect") as ColorRect).color)
	for label: Label in labels:
		label.modulate = final if fixed == Color(0x4A412A00) else fixed


func label_scan(node: Node) -> void:
	if node is Label:
		labels.append(node)
	for child: Node in node.get_children():
		label_scan(child)
## AUTO-CHANGE INVENTORY LABEL COLOR END


func toggle_invintory() -> void:
	undo_cursor_grab()
	refresh_visuals()
	if %InventoryContainer.get("visible"):
		%InventoryContainer.set("visible", false)
		%HotbarContainer.set("visible", true)
	else:
		%HotbarContainer.set("visible", false)
		%InventoryContainer.set("visible", true)

	#DEFAULT_SLOT := {
		#"name": "",
		#"description": "",
		#"icon": "",
		#"category": "",
		#"amount": 0.0,
		#"buyValue": 0.0,
		#"sellValue": 0.0,
	#}


func refresh_visuals() -> void:
	var index: int = -1 # inventory index start - 1
	var no_row: HSeparator = get_node("%s/Grid/HSeparator" % INV_PATH)
	for row: Panel in get_node("%s/Grid" % INV_PATH).get_children():
		if row == no_row: 
			continue
		for slot: Panel in row.get_children():
			index += 1
			var interact: Button = slot.get_node("Interact")
			var count: Label = slot.get_node("Count")
			var slot_data: Dictionary = inventory_contents[index]
			
			if slot_data.has("icon") and slot_data["icon"] != "":
				interact.set("icon", load( str(slot_data["icon"]) ))
			else:
				interact.icon = null
				
			count.text = "" if slot_data["amount"] == 0 else (
					str(round(slot_data["amount"]))
			)

	index = 23 # Hotbar index start - 1
	var no_slot: Panel = get_node("HotbarContainer/Slots/Gap")
	for slot: Panel in get_node("HotbarContainer/Slots").get_children():
		if slot == no_slot:
			continue
		index += 1
		var interact: Button = slot.get_node("Interact")
		var count: Label = slot.get_node("Count")
		var slot_data: Dictionary = inventory_contents[index]
		
		if slot_data.has("icon") and slot_data["icon"] != "":
			interact.icon = load(str(slot_data["icon"]))
		else:
			interact.icon = null
			
		count.text = "" if slot_data["amount"] == 0 else (
				str(round(slot_data["amount"]))
		)
		
	SaveLoad.save_value(INVENTORY_FILE_PATH, "content", inventory_contents)



func get_first_open_index() -> int:
	for i: int in range(INVENTORY_SIZE):
		if inventory_contents[i] == DEFAULT_SLOT:
			return i
	return -1


func swap_slot_to_cursor(index: int) -> void:
	if not (len(index) >= 0 or len(index) <= INVENTORY_SIZE):
		return
	
	var temp: Dictionary = inventory_contents[index]
	inventory_contents[index] = cursor_contents
	cursor_contents = temp


func swap_slot_to_slot(index: Array) -> void:
	var indexa: int = index[0]
	var indexb: int = index[1]
	if not (indexa >= 0 or indexa <= INVENTORY_SIZE):
		return
	if not (indexb >= 0 or indexb <= INVENTORY_SIZE):
		return
	
	var temp: Dictionary = inventory_contents[indexa]
	inventory_contents[indexa] = inventory_contents[indexb]
	inventory_contents[indexb] = temp
	
	refresh_visuals()


func undo_cursor_grab() -> void:
	if cursor_contents != DEFAULT_SLOT:
		inventory_contents[get_first_open_index()] = cursor_contents
	cursor_contents = DEFAULT_SLOT.duplicate(true)
	slots_queue.clear()



# TODO drag and drop items (visual more than anything)
# TODO grab half right click (grabs half or close and puts it on the cursor)
# TODO place half right click (conditional slot empty
# should i make it so it just swaps from the cursor not between both slots?
# TODO Shift-click move (quick move between inventory and hotbar or chests)
# TODO Alt-click use/equip (consumables, tools, equipable items)
# TODO Tooltip hover info (shows name, description, stats, etc.)
# TODO Save/load state (persistence between sessions)
# TODO add fixed vs relative option for Tooltips

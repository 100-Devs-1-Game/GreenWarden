class_name Hotbar
extends PanelContainer

signal equip_item(item: Item)

@onready var slots_parent_node: HBoxContainer = %Slots

var slots: Array[HotbarSlot]
var selected_index: int= 0



func _ready() -> void:
	for child in slots_parent_node.get_children():
		slots.append(child)
	update_selection()


func change_relative(delta: int):
	selected_index= wrapi(selected_index + delta, 0, slots.size())
	update_selection()


func change_absolute(idx: int):
	selected_index= idx
	update_selection()


func add_item(inv_item: InventoryItem):
	var slot: HotbarSlot= find_slot_with_type(inv_item.item_type)
	if not slot:
		slot= find_free_slot()
	slot.add_item(inv_item)


func use_item():
	var inv_item:= get_selected_inventory_item()
	assert(inv_item)
	inv_item.amount-= 1
	if inv_item.amount <= 0:
		remove_item()
	update_slot()


func update_selection():
	select_slot(selected_index)


func update_slot():
	get_selected_slot().update()


func remove_item():
	get_selected_slot().inv_item= null


func select_slot(idx: int):
	for slot in slots:
		slot.deselect()
	slots[idx].select()


func find_slot_with_type(item_type: Item)-> HotbarSlot:
	for slot in slots:
		if slot.inv_item and slot.inv_item.item_type == item_type:
			return slot
	return null


func find_free_slot()-> HotbarSlot:
	for slot in slots:
		if not slot.inv_item:
			return slot
	return null


func get_selected_slot()-> HotbarSlot:
	return slots[selected_index]


func get_selected_inventory_item()-> InventoryItem:
	return get_selected_slot().inv_item

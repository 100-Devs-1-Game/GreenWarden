class_name InventoryItem
extends Resource

@export var item_type: Item
@export var amount: int



func _init(_item: Item, _amount: int):
	item_type= _item
	amount= _amount

class_name InventoryItem
extends Resource

@export var item_type: Item
@export var amount: int= 1



func _init(_item: Item= null, _amount: int= 1):
	item_type= _item
	amount= _amount

class_name HotbarSlot
extends PanelContainer

@onready var color_rect: ColorRect = %ColorRect
@onready var texture_rect: TextureRect = %TextureRect
@onready var label_amount: Label = %"Label Amount"


var inv_item: InventoryItem:
	set(i):
		inv_item= i
		update()



func update():
	if inv_item:
		texture_rect.texture= inv_item.item_type.inventory_icon
		label_amount.text= str(inv_item.amount)
		label_amount.show()
	else:
		texture_rect.texture= null
		label_amount.hide()


func add_item(new_item: InventoryItem):
	assert(not inv_item or inv_item.item_type == new_item.item_type)
	if not inv_item:
		inv_item= new_item
	else:
		inv_item.amount+= new_item.amount
	update()


func select():
	color_rect.show()


func deselect():
	color_rect.hide()

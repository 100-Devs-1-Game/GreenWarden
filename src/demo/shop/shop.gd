class_name Shop
extends CanvasLayer

signal closed


@export var items: Array[Item]

@export var shop_item_label_settings: LabelSettings
@export var buy_button_scene: PackedScene

@onready var grid_container: GridContainer = %GridContainer



func _ready() -> void:
	populate_sell_list()


func populate_sell_list():
	for item: Item in items:
		var label_name:= Label.new()
		label_name.label_settings= shop_item_label_settings
		label_name.text= item.display_name
		grid_container.add_child(label_name)
		
		var label_cost:= Label.new()
		label_cost.label_settings= shop_item_label_settings
		label_cost.text= str("$", item.cost)
		grid_container.add_child(label_cost)
		
		var button: Button= buy_button_scene.instantiate()
		button.pressed.connect(on_buy_item.bind(item))
		grid_container.add_child(button)


func on_buy_item(item: Item):
	# TODO subtract money
	# Global.player.buy(item.cost)
	Global.player.add_item(InventoryItem.new(item, 1))


func _on_button_close_pressed() -> void:
	closed.emit()

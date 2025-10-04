class_name Shop
extends CanvasLayer

signal closed


@export var seeds: Array[SeedItem]
@export var tools: Array[Item]

@export var shop_item_label_settings: LabelSettings
@export var buy_button_scene: PackedScene

@onready var grid_container_seeds: GridContainer = %"GridContainer Seeds"
@onready var grid_container_tools: GridContainer = %"GridContainer Tools"



func _ready() -> void:
	populate_sell_list(grid_container_seeds, seeds)
	populate_sell_list(grid_container_tools, tools)


func populate_sell_list(container: GridContainer, items: Array):
	for item: Item in items:
		var label_name:= Label.new()
		label_name.label_settings= shop_item_label_settings
		label_name.text= item.display_name
		container.add_child(label_name)
		
		var label_cost:= Label.new()
		label_cost.label_settings= shop_item_label_settings
		label_cost.text= str("$", item.cost)
		container.add_child(label_cost)
		
		var button: Button= buy_button_scene.instantiate()
		button.pressed.connect(on_buy_item.bind(item))
		container.add_child(button)


func on_buy_item(item: Item):
	# TODO subtract money
	# Global.player.buy(item.cost)
	Global.player.add_item(InventoryItem.new(item, 1))


func _on_button_close_pressed() -> void:
	closed.emit()

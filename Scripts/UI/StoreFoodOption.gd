class_name StoreFoodOption extends Control


@export var component: Menu.FoodComponent
@export var texture: Texture2D

var price: float


signal status_message(msg: String, status: StoreControl.StatusType)


func _ready() -> void:
	%ItemName.text = Menu.get_food_component_name(component)
	price = Menu.get_item_wholesale_price(component)
	%ItemPrice.text = Global.format_money(price)
	$TextureRect.texture = texture
	display_number_in_inventory()


func display_number_in_inventory() -> void:
	var count = ProgressManager.get_food_avaiable_count(component)
	%InventoryCount.text = "%d in inventory" % count


func buy_item() -> void:
	if ProgressManager.money < price:
		status_message.emit(
			"🗙 Not enough money",
			StoreControl.StatusType.ERR
		)
		return
	
	ProgressManager.money -= price
	var item = ProgressManager.StoredFoodComponent.new(component)
	ProgressManager.stock.append(item)
	ProgressManager.save_progress()
	display_number_in_inventory()
	
	status_message.emit(
		"✔ Purchased",
		StoreControl.StatusType.OK
	)

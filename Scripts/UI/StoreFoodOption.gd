@tool
class_name StoreFoodOption extends Control


@export var component: Menu.FoodComponent
@export var texture: Texture2D
@export var margin_fraction: float = 0.1

var price: float


signal status_message(msg: String, status: StoreControl.StatusType)


func _ready() -> void:
	handle_resize()
	if not Engine.is_editor_hint():
		get_parent().resized.connect(handle_resize)
	
	%ItemName.text = Menu.get_food_component_name(component)
	price = Menu.get_item_wholesale_price(component)
	%ItemPrice.text = Utils.format_money(price)
	%TextureRect.texture = texture
	display_inventory_counts()


func handle_resize() -> void:
	var margin_value: float = size.y * margin_fraction
	var inner: MarginContainer = %InnerMargin
	inner.add_theme_constant_override("margin_top", margin_value)
	inner.add_theme_constant_override("margin_left", margin_value)
	inner.add_theme_constant_override("margin_bottom", margin_value)
	inner.add_theme_constant_override("margin_right", margin_value)


func display_inventory_counts() -> void:
	var count: int = 0
	if not Engine.is_editor_hint():
		count = ProgressManager.get_food_available_count(component)
	%InventoryCount.text = "%d in inventory" % count
	
	var expiring_today: int = 0
	if not Engine.is_editor_hint():
		expiring_today = ProgressManager.get_food_expiring_today_count(component)
	if expiring_today == 0:
		%ExpiringToday.visible = false
	else:
		%ExpiringToday.visible = true
		%ExpiringToday.text = " %d expiring today " % expiring_today
		%ExpiringToday.update_badge()


func buy_item() -> void:
	if ProgressManager.money < price:
		status_message.emit(
			"✖ Not enough money",
			StoreControl.StatusType.ERR
		)
		return
	
	ProgressManager.money -= price
	var item = ProgressManager.StoredFoodComponent.new(component)
	ProgressManager.stock.append(item)
	ProgressManager.save_progress()
	display_inventory_counts()
	
	status_message.emit(
		"✔ Purchased",
		StoreControl.StatusType.OK
	)

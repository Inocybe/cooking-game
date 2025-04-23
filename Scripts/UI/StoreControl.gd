class_name StoreControl extends Control


enum StatusType {
	OK,
	ERR
}

@onready var status_badge: Badge = %StatusBadge

@export var food_options: Array[StoreFoodOption]


const RECOMMENDED_FOOD_AMOUNTS: Dictionary[Menu.FoodComponent, int] = {
	Menu.FoodComponent.Bun: 4,
	Menu.FoodComponent.Burger: 4,
	Menu.FoodComponent.Fries: 4,
	Menu.FoodComponent.Cup: 4
}


func _ready() -> void:
	for food_option: StoreFoodOption in food_options:
		food_option.status_message.connect(display_status_message)


func display_status_message(msg: String, status: StatusType):
	status_badge.text = msg
	status_badge.bg_color = get_status_color(status)
	status_badge.update_badge()
	status_badge.visible = true
	$StatusVanishTimer.start()


static func get_status_color(status: StatusType) -> Color:
	return {
		StatusType.OK: Color.DARK_GREEN,
		StatusType.ERR: Color.DARK_RED
	}[status]


static func has_recommended_food_amounts() -> bool:
	for food in RECOMMENDED_FOOD_AMOUNTS.keys():
		var amount_now = ProgressManager.get_food_avaiable_count(food)
		var amount_recommended = RECOMMENDED_FOOD_AMOUNTS[food]
		if amount_now < amount_recommended:
			return false
	return true

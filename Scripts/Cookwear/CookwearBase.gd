class_name CookwearBase extends StaticBody3D


enum CookingType {
	Cooktop,
	Fryer
}


@export var cooking_area: Area3D = null

@export var cooking_type: CookingType

var food_cooking: Array[Node3D] = []


func _ready() -> void:
	if cooking_area:
		cooking_area.body_entered.connect(on_body_entered)
		cooking_area.body_exited.connect(on_body_exited)


func on_body_entered(body: Node3D):
	var cookables = body.find_children("*", "Cookable")
	if cookables.size() > 0:
		cookables[0].on_start_cooking(cooking_type)
		food_cooking.append(body)
		food_exit_enter.emit(self)


func on_body_exited(body: Node3D):
	var cookables = body.find_children("*", "Cookable")
	if cookables.size() > 0:
		cookables[0].on_stop_cooking(cooking_type)
		food_cooking.erase(body)
		food_exit_enter.emit(self)


signal food_exit_enter(CookwearBase)

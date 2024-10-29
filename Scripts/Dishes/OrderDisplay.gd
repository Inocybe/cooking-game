extends Node3D


# MAKE IN SAME ORDER AS MENU ITEMS
@export var food_sprites: Array[CompressedTexture2D]
@export var positions: Array[Sprite3D]



var player: CharacterBody3D = null



func _ready() -> void:
	player = Global.game_manager.player


func _process(delta: float) -> void:
	look_at(player.global_transform.origin, Vector3(0, 1, 0))


func set_order_display(items: Array[Menu.Item]) -> void:
	for i: int in range(items.size()):
		positions[i].texture = food_sprites[items[i]]

extends Node3D


func _ready() -> void:
	$DeleteArea.body_entered.connect(body_entered_can)


func body_entered_can(body: Node3D) -> void:
	if body.is_in_group("holdable") and not body.freeze and body is not Dish:
		body.get_parent().remove_child(body)
		if not $TrashSound.playing:
			$TrashSound.play()

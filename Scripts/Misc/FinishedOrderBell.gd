extends Node3D


func on_start_interact() -> void:
	if not $BellSwingAnimation.is_playing():
		Global.order_manager.call_customers_with_completed_orders()
		$BellSoundPlayer.play()
		$BellSwingAnimation.play("swing")

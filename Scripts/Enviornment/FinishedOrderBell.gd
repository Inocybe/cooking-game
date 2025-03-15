extends Node3D


func on_start_interact() -> void:
	if not $BellSwingAnimation.is_playing():
		Global.game_manager.order_manager.call_customers_back()
		$BellSoundPlayer.play()
		$BellSwingAnimation.play("swing")

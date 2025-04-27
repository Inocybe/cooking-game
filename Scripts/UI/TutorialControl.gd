extends Control


class TutorialStep:
	var text: String
	var completed: Signal
	var show_OK_btn: bool
	
	func _init(text_: String, completed_: Signal,
		show_OK_btn_: bool = false) -> void:
		self.text = text_
		self.completed = completed_
		self.show_OK_btn = show_OK_btn_


var tutorial_steps: Array[TutorialStep]

var step_idx: int = -1

@onready var steps_text: RichTextLabel = %StepsText


func _ready() -> void:
	Global.notify_has_XR(on_has_XR_detected)


func on_has_XR_detected(has_XR: bool) -> void:
	if has_XR:
		load_XR_tutorial()
	else:
		load_non_XR_tutorial()
	
	if ProgressManager.day == 1:
		start_tutorial()


func load_XR_tutorial() -> void:
	tutorial_steps = [
		TutorialStep.new("Use the joysticks to move",
			Global.game_manager.player.movement),
		TutorialStep.new("Press the grip to point",
			Global.xr_manager.pointed),
		TutorialStep.new("Point and touch a button to press it.",
			%OKButton.pressed, true),
		TutorialStep.new("To your right, food is avaliable. Grab it by pressing the trigger.",
			Global.xr_manager.grabbed_thing),
		TutorialStep.new("Customers will wait to order to your right. Point at them to take their order.",
			Global.game_manager.order_manager.order_requested),
		TutorialStep.new("Once you fufill their order, call the customer with the bell.",
			Global.game_manager.order_manager.called_customers_back),
		TutorialStep.new("You're all set!",
			%OKButton.pressed, true)
	]


func load_non_XR_tutorial() -> void:
	tutorial_steps = [
		TutorialStep.new("Use the mouse to look around.",
			Global.game_manager.player.look_around),
		TutorialStep.new("Use WASD to move.",
			Global.game_manager.player.movement),
		TutorialStep.new("Interact with objects by clicking or pressing 'E'.",
			%OKButton.pressed, true),
		TutorialStep.new("To your right, food is avaliable. Pick it up by interacting with it.",
			Global.game_manager.player.camera.picked_up_thing),
		TutorialStep.new("Use the scroll wheel to move it towards and away from you.",
			Global.game_manager.player.camera.scroll_moved_thing),
		TutorialStep.new("Customers will wait to order to your right. Interact with them to take their order.",
			Global.game_manager.order_manager.order_requested),
		TutorialStep.new("Once you fufill their order, call the customer with the bell.",
			Global.game_manager.order_manager.called_customers_back),
		TutorialStep.new("You're all set!",
			%OKButton.pressed, true)
	]


func close_tutorial() -> void:
	visible = false


func start_tutorial() -> void:
	visible = true
	step_idx = -1
	next_step()


func add_step_line(completed: bool, step: TutorialStep):
	steps_text.append_text(
		("☒ " if completed else "☐ ") + step.text
	)
	steps_text.newline()


func show_steps() -> void:
	steps_text.clear()
	for i in range(step_idx):
		add_step_line(true, tutorial_steps[i])
	var current_step: TutorialStep = tutorial_steps[step_idx]
	add_step_line(false, current_step)
	%OKButton.visible = current_step.show_OK_btn


func next_step() -> void:
	if not visible:
		return
	
	step_idx += 1
	if step_idx == len(tutorial_steps):
		end_tutorial()
		return
	
	var step: TutorialStep = tutorial_steps[step_idx]
	show_steps()
	step.completed.connect(next_step, CONNECT_ONE_SHOT)


func end_tutorial() -> void:
	close_tutorial()

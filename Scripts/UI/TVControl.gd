class_name TVControl extends Control


@onready var revenue: Label = %RevenueDisplay
@onready var served_today: Label = %ServedTodayDisplay
@onready var time_remaining: Label = %TimeRemaining

@export var font_size: int = 18


func _ready() -> void:
	var our_theme: Theme = ThemeDB.get_project_theme().duplicate()
	
	our_theme.default_font_size = font_size
	
	theme = our_theme


func set_latest_review(score: float, review: String) -> void:
	%ReviewAnimator.play("fade_out")
	await %ReviewAnimator.animation_finished
	%ReviewScore.text = "%.f/10 -" % (score * 10)
	if not review.contains("\n"):
		review = review + "\n"
	%ReviewText.text = review
	%ReviewAnimator.play("fade_in")

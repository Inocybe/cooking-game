extends AudioStreamPlayer3D


@export var bump_min_impulse: float = 0.5
@export var bump_highest_impulse: float = 3
@export var bump_base_db: float = -30
@export var bump_highest_db: float = 30

var rigid_body: RigidBodyBase


func _ready() -> void:
	rigid_body = get_parent()
	rigid_body.contact_monitor = true
	rigid_body.max_contacts_reported = 8


func _process(_delta: float) -> void:
	return
	
	if rigid_body.freeze:
		return
	
	var state: PhysicsDirectBodyState3D = rigid_body.body_state
	
	if not state:
		return
	
	for i in range(state.get_contact_count()):
		var impulse: Vector3 = state.get_contact_impulse(i)
		
		var impulse_amount: float = impulse.length()
		if impulse_amount >= bump_min_impulse:
			do_bump_sound(impulse_amount)


func do_bump_sound(impulse_amount: float) -> void:
	if not playing:
		impulse_amount = min(impulse_amount, bump_highest_impulse)
		var bump_frac: float = (impulse_amount - bump_min_impulse) / (bump_highest_impulse - bump_min_impulse)
		var db: float = bump_base_db + bump_frac * (bump_highest_db - bump_base_db)
		volume_db = db
		play()

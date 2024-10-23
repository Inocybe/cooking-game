class_name CheckingUpsideDown

const SPILL_ANGLE: float = PI / 3


func IsUpsideDown(object: Holdable) -> bool:
	return object.facing_direction().angle_to(Vector3.UP) > SPILL_ANGLE

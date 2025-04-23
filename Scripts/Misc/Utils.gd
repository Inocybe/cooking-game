class_name Utils extends RefCounted


static func frame_lerp(from: float, to: float, speed: float, delta: float):
	var lerp_amount: float = 1 - (1 - speed) ** delta
	return lerp(from, to, lerp_amount)


static func weighted_random_int(weights: Array) -> int:
	var total_weight: float = 0
	for weight in weights:
		total_weight += weight
	var value: float = randf() * total_weight
	var range_min = 0
	for i in range(len(weights)):
		var range_max = range_min + weights[i]
		if value < range_max:
			return i
		range_min = range_max
	return -1 # unreachable


static func weighted_random_val(values: Dictionary) -> Variant:
	return values.keys()[weighted_random_int(values.values())]


static func format_money(money: float) -> String:
	return "$%.2f" % money


static func format_time(time: float) -> String:
	return "%d:%02d" % [time / 60, fmod(time, 60)]

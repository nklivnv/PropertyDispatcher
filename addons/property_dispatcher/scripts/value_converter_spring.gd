@tool
extends ValueConverter
class_name ValueConverterSpring


@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_NIL_IS_VARIANT) var speed: Variant = 0.0
@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_NIL_IS_VARIANT) var value: Variant = 0.0
@export var frequency: float = 8.0


func convert(target: Variant) -> Variant:
	if not [speed, value].all(is_instance_of.bind(typeof(target))):
		push_error("ValueConverterSpring.convert() - Type error")
		return target
	
	var delta: float = minf(1.0 / Engine.get_frames_per_second(), 0.033)
	var force: float = frequency * frequency * (target - value) - 2.0 * frequency * speed
	speed += force * delta
	value += speed * delta
	return value

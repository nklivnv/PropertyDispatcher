@tool
extends ValueConverter
class_name ValueConverterCurve


enum DefaultMode {CLAMP, WRAP, SOURCE}


@export var curve: Curve = _get_default_curve()

@export_group("Default Mode", "default_mode")
@export var default_mode_left := DefaultMode.CLAMP
@export var default_mode_right := DefaultMode.CLAMP


func _property_can_revert(property: StringName) -> bool:
	return property == "curve"


func _property_get_revert(property: StringName) -> Variant:
	return _get_default_curve() if property == "curve" else null


func convert(what: Variant) -> Variant:
	if what is not float and what is not int: return what
	if not curve: return what
	
	if what < curve.min_domain: return _sample_default(what, default_mode_left)
	elif what > curve.max_domain: return _sample_default(what, default_mode_right)
	
	return curve.sample(what)


func _sample_default(offset: float, mode: DefaultMode) -> float:
	match mode:
		DefaultMode.CLAMP: return curve.sample(offset)
		DefaultMode.WRAP: return curve.sample(wrapf(offset, curve.min_domain, curve.max_domain))
	return offset


static func _get_default_curve() -> Curve:
	var default_curve := Curve.new()
	default_curve.add_point(Vector2.ZERO, 0, 1, Curve.TANGENT_LINEAR, Curve.TANGENT_LINEAR)
	default_curve.add_point(Vector2.ONE, 1, 0, Curve.TANGENT_LINEAR, Curve.TANGENT_LINEAR)
	return default_curve

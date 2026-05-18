@tool
extends ValueConverter
class_name ValueConverterMap


enum DefaultMode {SOURCE_VALUE, CUSTOM_VALUE, CONVERTER}


@export var map: Dictionary
@export var default_mode: DefaultMode = DefaultMode.SOURCE_VALUE

var default_value: Variant
var default_converter: ValueConverter


func _validate_property(property: Dictionary) -> void:
	match property.name:
		"map":
			var value_type: Variant.Type = _find_inspected_property_converter_value_type()
			property.hint_string = "%d/:;%d/:" % [value_type, value_type]
		"default_mode": property.usage |= PROPERTY_USAGE_UPDATE_ALL_IF_MODIFIED
		"default_value" when default_mode == DefaultMode.CUSTOM_VALUE:
			property.type = _find_inspected_property_converter_value_type()
			property.usage = PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_NIL_IS_VARIANT
		"default_converter" when default_mode == DefaultMode.CONVERTER:
			property.hint = PROPERTY_HINT_RESOURCE_TYPE
			property.hint_string = "ValueConverter"
			property.usage = PROPERTY_USAGE_DEFAULT


func _find_inspected_property_converter_value_type() -> Variant.Type:
	var inspected_object: Object = EditorInterface.get_inspector().get_edited_object()
	return typeof(inspected_object.get_value()) if inspected_object is PropertyConverter else TYPE_NIL


func convert(whan: Variant) -> Variant:
	if whan in map: return map[whan]
	elif default_mode == DefaultMode.CUSTOM_VALUE: return default_value
	elif default_mode == DefaultMode.CONVERTER and default_converter: return default_converter.convert(whan)
	return whan

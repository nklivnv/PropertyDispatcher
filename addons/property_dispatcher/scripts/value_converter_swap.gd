@tool
extends ValueConverter
class_name ValueConverterSwap


@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_NIL_IS_VARIANT)
var primary_value: Variant = true


@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_NIL_IS_VARIANT)
var secondary_value: Variant = false


func convert(value: Variant) -> Variant:
	return primary_value if not is_same(value, primary_value) else secondary_value


func _validate_property(property: Dictionary) -> void:
	match property.name:
		"primary_value", "secondary_value":
			var inspected_object: Object = EditorInterface.get_inspector().get_edited_object()
			if inspected_object is PropertyConverter:
				property.type = typeof(inspected_object.get_value())

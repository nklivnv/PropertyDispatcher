@tool
extends ValueConverter
class_name ValueConverterStack


@export var stack: Array[ValueConverter]


func convert(value: Variant) -> Variant:
	return stack.filter(is_instance_valid).reduce(
		func(result: Variant, converter: ValueConverter) -> Variant: return converter.convert(result), value)

@tool
@icon("../icons/property_converter.svg")
extends PropertyDispatcher
class_name PropertyConverter 


@export var converter: ValueConverter


func update() -> void:
	if not allow_editor and Engine.is_editor_hint(): push_warning("PropertyConverter.update() - allow_editor != true")
	elif converter: set_value(converter.convert(get_value()))

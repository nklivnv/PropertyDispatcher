@tool
extends ValueConverter
class_name ValueConverterShift


@export_tool_button("Shift") var shift_action := shift


@export var array: Array:
	set(new):
		array = new
		set_index(clampi(index, -1, len(array)-1))


@export var default_offset: int = 1


@export var index: int = -1:
	set = set_index


@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_READ_ONLY | PROPERTY_USAGE_NIL_IS_VARIANT)
var value: Variant:
	get = get_value


func get_value() -> Variant: return array[index] if index != -1 else null


func get_shifted(p_offset: int = default_offset, start_index: int = index) -> Variant:
	set_index(wrapi(start_index + p_offset, 0, len(array)))
	return get_value()


func shift(p_offset: int = default_offset, start_index: int = index) -> void:
	set_index(wrapi(start_index + p_offset, 0, len(array)))


func shift_from_value(from_value: Variant, p_offset: int = default_offset, start_index: int = index) -> void:
	set_index(wrapi(array.find(from_value, start_index) + p_offset, 0, len(array)))


func shift_and_skip(p_offset: int = default_offset, start_index: int = index) -> void:
	var size: int = array.size()
	if size == 0: return
	var start: int = clampi(start_index, 0, size - 1)
	var old_val: Variant = array[start]
	var new_idx: int = wrapi(start + p_offset, 0, size)
	while new_idx != start and array[new_idx] == old_val:
		new_idx = wrapi(new_idx + sign(p_offset), 0, size)
	set_index(-1 if array[new_idx] == old_val else new_idx)


func shift_and_skip_from_value(from_value: Variant, p_offset: int = default_offset, start_index: int = index) -> void:
	var size: int = array.size()
	if size == 0: return
	var start: int = clampi(start_index, 0, size - 1)
	var found: int = array.find(from_value, start)
	if found == -1: return
	var new_idx: int = wrapi(found + p_offset, 0, size)
	while new_idx != found and array[new_idx] == from_value:
		new_idx = wrapi(new_idx + sign(p_offset), 0, size)
	set_index(-1 if array[new_idx] == from_value else new_idx)


func array_get_value(array_index: int) -> Variant:
	return array[array_index] if array_index >= 0 and array_index < len(array) else null


func set_index(new: int) -> void:
	new = clampi(new, -1, len(array)-1)
	index = new


func convert(start_index: Variant) -> Variant:
	shift(default_offset, start_index)
	return get_value()

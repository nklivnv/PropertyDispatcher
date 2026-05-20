@tool
@icon("../icons/property_connector.svg")
extends PropertyDispatcher
class_name PropertyConnector


@export_tool_button("Update") var update_action := update


@export var allow_editor: bool
@export_storage var _converters: Array[ValueConverter]
@export_storage var _target_object_paths: Array[NodePath]
@export_storage var _target_objects: Array[Object]
@export_storage var _target_property_paths: Array[NodePath]
var _target_values: Array[Variant]


func _enter_tree() -> void:
	_resize_arrays()
	_update_target_objects()


func _update_target_objects() -> void:
	for i in target_count:
		var path: NodePath = _target_object_paths[i]
		if path: _on_target_object_path_changed(i)


func update() -> void:
	
	if not allow_editor and Engine.is_editor_hint(): push_warning("PropertyConnector.update() - allow_editor != true")
	else:
		var converted_value: Variant = get_value()
		for i in target_count:
			var converter: ValueConverter = _converters[i]
			if converter: converted_value = converter.convert(converted_value)
			target_set_value(i, converted_value)


var target_count: int:
	get: return len(_converters)
	set(new):
		_converters.resize(new)
		_resize_arrays()
		notify_property_list_changed()


func _resize_arrays() -> void:
	_target_object_paths.resize(target_count)
	_target_objects.resize(target_count)
	_target_property_paths.resize(target_count)
	_target_values.resize(target_count)


func _get_property_list() -> Array[Dictionary]:
	var property_list: Array[Dictionary]
	for i in target_count:
		var target_object: Object = target_get_object(i)
		var target_object_path: NodePath = _target_object_paths[i]
		property_list.append_array([
			{ name = "stack/%d/converter" % i, type = TYPE_OBJECT, hint = PROPERTY_HINT_RESOURCE_TYPE, hint_string = "ValueConverter"},
			{ name = "stack/%d/object_path" % i, type = TYPE_NODE_PATH,
				hint = PROPERTY_HINT_NODE_PATH_VALID_TYPES,
				usage = PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_UPDATE_ALL_IF_MODIFIED},
			{ name = "stack/%d/object" % i,
				type = TYPE_OBJECT,
				hint = PROPERTY_HINT_NODE_TYPE if target_object is Node else PROPERTY_HINT_RESOURCE_TYPE,
				hint_string = "" if target_object is Node else "Resource",
				usage = ((PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_READ_ONLY) if target_object_path else PROPERTY_USAGE_DEFAULT) | PROPERTY_USAGE_UPDATE_ALL_IF_MODIFIED},
			{ name = "stack/%d/property_path" % i, type = TYPE_STRING,
				hint = PROPERTY_HINT_ENUM_SUGGESTION,
				hint_string = "" if target_object == self else ",".join(FUNCS.get_object_property_names(target_object)),
				usage = (PROPERTY_USAGE_EDITOR if target_object else PROPERTY_USAGE_NONE) | PROPERTY_USAGE_NIL_IS_VARIANT},
			{ name = "stack/%d/value" % i, type = TYPE_NIL, usage = PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_NIL_IS_VARIANT},
		])
	
	return property_list


func _validate_property(property: Dictionary) -> void:
	super(property)
	match property.name:
		"target_count":
			property.usage = PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_ARRAY
			property.class_name = "Stack,stack/"


func _get(property: StringName) -> Variant:
	if not property.begins_with("stack/"): return
	var slice_1: String = property.get_slice("/", 1) 
	if not slice_1.is_valid_int(): return
	var index: int = slice_1.to_int()
	match property.get_slice("/", 2):
		"converter": return _converters[index]
		"object_path": return target_get_object_path(index)
		"object": return target_get_object(index)
		"property_path": return target_get_property_path(index)
		"value": return target_get_value(index)
	return 


func _set(property: StringName, new: Variant) -> bool:
	if not property.begins_with("stack/"): return false
	var slice_1: String = property.get_slice("/", 1)
	if not slice_1.is_valid_int(): return false
	var index: int = slice_1.to_int()
	match property.get_slice("/", 2):
		"converter": _converters[index] = new
		"object_path": target_set_object_path(index, new)
		"object": target_set_object(index, new)
		"property_path": target_set_property_path(index, new)
		"value": target_set_value(index, new)
		_: return false
	return true


func _property_can_revert(property: StringName) -> bool:
	if not property.get_slice("/", 0) == "stack": return false
	if not property.get_slice("/", 1).is_valid_int(): return false
	return property.get_slice("/", 2) in ["converter", "object_path", "object", "property_path", "value"]


func _property_get_revert(property: StringName) -> Variant:
	match property.get_slice("/", 2):
		"converter", "object": return null
		"object_path", "property_path": return ^""
		"value" when object and String(property_path) in object: return ClassDB.class_get_property_default_value(object.get_class(), String(property_path))
	return 


func _on_target_object_path_changed(index: int) -> void:
	var target_object_path: NodePath = _target_object_paths[index]
	var target_object: Object = _target_objects[index]
	
	var node_and_resource: Array = get_node_and_resource(target_object_path)
	var node: Node = node_and_resource[0]
	var resource: Resource = node_and_resource[1]
	var property: NodePath = node_and_resource[2]
	_target_objects[index] = resource if resource else node if node else target_object if target_object is not Node else null
	if property: _target_property_paths[index] = property


func target_get_object_path(index: int) -> NodePath: return _target_object_paths[index]
func target_set_object_path(index: int, new: NodePath) -> void:
	if _target_object_paths[index] == new: return
	_target_object_paths[index] = new
	_on_target_object_path_changed(index)


func target_get_object(index: int) -> Object: return _target_objects[index]
func target_set_object(index: int, new: Object) -> void:
	if is_same(new, _target_objects[index]): return
	_target_objects[index] = new
	_target_object_paths[index] = get_path_to(new) if new is Node else ^""


func target_get_property_path(index: int) -> NodePath: return _target_property_paths[index]
func target_set_property_path(index: int, new: NodePath) -> void:
	_target_property_paths[index] = new
	notify_property_list_changed()


func target_get_value(index: int) -> Variant:
	var target_object: Object = _target_objects[index]
	var target_property_path: NodePath = _target_property_paths[index]
	return target_object.get_indexed(target_property_path) if target_object and target_property_path else target_object if target_object else _target_values[index]


func target_set_value(index: int, new: Variant) -> void:
	_target_values[index] = new
	var target_object: Object = _target_objects[index]
	var target_property_path: NodePath = _target_property_paths[index]
	if target_object: target_object.set_indexed(target_property_path, new)

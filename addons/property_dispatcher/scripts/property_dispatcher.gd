@tool
@icon("../icons/property_dispatcher.svg")
extends Node
class_name PropertyDispatcher


const FUNCS: GDScript = preload("funcs.gd")


enum UpdateMode {PHYSICS, IDLE, MANUAL}


@export var update_mode := UpdateMode.MANUAL


@export_custom(PROPERTY_HINT_NODE_PATH_VALID_TYPES, "", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_UPDATE_ALL_IF_MODIFIED)
var object_path: NodePath:
	get: return object_path
	set(new):
		if object_path == new: return 
		object_path = new
		if is_inside_tree(): _on_object_path_changed()


var object: Object:
	get: return _object
	set(new):
		if is_same(new, _object): return
		_object = new
		object_path = get_path_to(new) if new is Node else ^""


var property_path: NodePath


var value: Variant:
	get = get_value,
	set = set_value


var _object: Object
var _value: Variant


signal value_changed(value: Variant)


func _ready() -> void:_on_object_path_changed()


func _process(_delta: float) -> void:
	if update_mode == UpdateMode.IDLE: update()


func _physics_process(_delta: float) -> void:
	if update_mode == UpdateMode.PHYSICS: update()


func update() -> void: set_value(get_value())


func _on_object_path_changed() -> void:
	var node_and_resource: Array = get_node_and_resource(object_path)
	var node: Node = node_and_resource[0]
	var resource: Resource = node_and_resource[1]
	_object = resource if resource else node if node else _object if _object is not Node else null
	if node_and_resource[2]: property_path = node_and_resource[2]


func get_value() -> Variant:
	return object.get_indexed(property_path) if object and property_path else object if object else _value


func set_value(new: Variant) -> void:
	if is_same(_value, new): return
	_value = new
	if object: object.set_indexed(property_path, new)
	value_changed.emit(new)


func _validate_property(p: Dictionary) -> void:
	match p.name:
		"_object" when not object_path: p.usage = PROPERTY_USAGE_STORAGE
		"object":
			p.hint = PROPERTY_HINT_NODE_TYPE if object is Node else PROPERTY_HINT_RESOURCE_TYPE
			p.hint_string = "" if object is Node else "Resource"
			p.usage = ((PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_READ_ONLY) if object_path else PROPERTY_USAGE_DEFAULT) | PROPERTY_USAGE_UPDATE_ALL_IF_MODIFIED
		"property_path":
			p.type = TYPE_STRING
			p.hint = PROPERTY_HINT_ENUM_SUGGESTION
			if _object != self: p.hint_string = ",".join(FUNCS.get_object_property_names(object)) if object else ""
			p.usage = (PROPERTY_USAGE_DEFAULT if object else PROPERTY_USAGE_NONE) | PROPERTY_USAGE_NIL_IS_VARIANT | PROPERTY_USAGE_UPDATE_ALL_IF_MODIFIED
		"value":
			if object and property_path: p.type = typeof(get_value())
			p.usage = (PROPERTY_USAGE_EDITOR if object else PROPERTY_USAGE_DEFAULT) | PROPERTY_USAGE_NIL_IS_VARIANT


func _property_can_revert(property: StringName) -> bool:
	return property == "object" or (property == "value" and object)


func _property_get_revert(property: StringName) -> Variant:
	match property:
		"object": return null
		"value" when object and StringName(property_path) in object:
			return ClassDB.class_get_property_default_value(object.get_class(), StringName(property_path))
	return null

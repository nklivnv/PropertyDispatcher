@tool
extends ValueConverter
class_name ValueConverterExpression


const FUNCS: GDScript = preload("funcs.gd")


static var _engine_singletons: Array = Array(Engine.get_singleton_list()).map(Engine.get_singleton)
var _expr: Expression


@export var include_engine_singletons: bool:
	set(new):
		include_engine_singletons = new
		FUNCS.SingleCall.request(_update_expression)


@export_custom(PROPERTY_HINT_EXPRESSION, "") var expression: String:
	set(new):
		expression = new
		FUNCS.SingleCall.request(_update_expression)


func _update_expression() -> void:
		_expr = Expression.new()
		var names := PackedStringArray(["value"]) + input_names
		if include_engine_singletons: names += Engine.get_singleton_list()
		if _expr.parse(expression, names) != OK: _expr = null
		#_singletons = Array(Engine.get_singleton_list()).map(Engine.get_singleton) if _expr else []


@export var input_names: PackedStringArray:
	set(new):
		input_names = new
		FUNCS.SingleCall.request(_update_expression)


@export var input_values: Array


@export_custom(PROPERTY_HINT_NODE_TYPE, "", PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_NIL_IS_VARIANT | PROPERTY_USAGE_READ_ONLY)
var converted_value: Variant


func convert(what: Variant) -> Variant:
	var values: Array = [what]
	if input_values: values += input_values
	if include_engine_singletons: values += _engine_singletons
	converted_value = _expr.execute(values, self) if _expr else what
	return converted_value

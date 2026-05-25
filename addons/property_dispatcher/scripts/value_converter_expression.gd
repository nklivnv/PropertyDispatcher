@tool
extends ValueConverter
class_name ValueConverterExpression


static var _engine_singletons: Array
var _expr: Expression


@export_tool_button("Convert Empty") var convert_empty_action := convert.bind(null)


@export var include_engine_singletons: bool:
	set(new):
		include_engine_singletons = new
		SingleCall.request(_update_expression)


@export_custom(PROPERTY_HINT_EXPRESSION, "") var expression: String:
	set(new):
		expression = new
		SingleCall.request(_update_expression)


@export var input_names: PackedStringArray:
	set(new):
		input_names = new
		SingleCall.request(_update_expression)


@export var input_values: Array


#@export_custom(PROPERTY_HINT_NODE_TYPE, "", PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_NIL_IS_VARIANT | PROPERTY_USAGE_READ_ONLY)
@export var value: Variant


static func _update_engine_singlitons() -> void:
	_engine_singletons = Array(Engine.get_singleton_list()).map(Engine.get_singleton)


func _update_expression() -> void:
	_expr = Expression.new()
	var names := PackedStringArray(["value"]) + input_names
	if include_engine_singletons:
		_update_engine_singlitons()
		names += Engine.get_singleton_list()
	if _expr.parse(expression, names) != OK: _expr = null


func convert(what: Variant) -> Variant:
	var values: Array = [what]
	if input_values: values += input_values
	if include_engine_singletons: values += _engine_singletons
	value = _expr.execute(values, self) if _expr else what
	return value

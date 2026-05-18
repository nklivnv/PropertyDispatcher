@abstract
extends Object


@abstract class SingleCall:
	
	static var _queue: Dictionary[Callable, bool]
	
	static func request(callable: Callable) -> void:
		if callable in _queue: return
		_queue[callable] = true
		callable.call_deferred()
		erase.call_deferred(callable)
	
	static func erase(callable: Callable) -> void:
		_queue.erase(callable)
	
	static func clear() -> void: _queue.clear()


static func get_object_property_names(object: Object, usage: PropertyUsageFlags = PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE) -> PackedStringArray:
	return [] if not object else object.get_property_list(
		).filter(func(p: Dictionary) -> bool: return p.usage & usage
		).map(func(p: Dictionary) -> String: return String(p.name))#.to_snake_case())

@tool
extends EditorPlugin


func _enable_plugin() -> void:
	#add_custom_type("PropertyDispatcher", "Node", preload("uid://r0iryoj7sn7l"), preload("uid://d1p855ylxsjma"))
	pass


func _disable_plugin() -> void:
	#remove_custom_type("PropertyDispatcher")
	pass


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass

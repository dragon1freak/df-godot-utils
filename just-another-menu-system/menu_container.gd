extends Control
class_name MenuContainer


@export var start_open := false
@export var mouse_mode : MouseFilter = MouseFilter.MOUSE_FILTER_PASS

# Should add an is_open flag
var is_open := false


#func _ready() -> void:
	#mouse_filter = mouse_mode


func open() -> void:
	is_open = true
	visible = true


func close() -> void:
	is_open = false
	visible = false

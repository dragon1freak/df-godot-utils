extends Control
class_name MenuContainer


@export var start_open := false


# Should add an is_open flag
var is_open := false


func open() -> void:
	is_open = true
	visible = true


func close() -> void:
	is_open = false
	visible = false

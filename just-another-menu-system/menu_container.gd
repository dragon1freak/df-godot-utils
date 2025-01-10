extends Control
class_name MenuContainer


@export var start_open := false


# Should add an is_open flag
var is_open := false


func open() -> void:
	is_open = true
	on_open()


func close() -> void:
	is_open = false
	on_close()


func on_open() -> void:
	visible = false


func on_close() -> void:
	visible = false

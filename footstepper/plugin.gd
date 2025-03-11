@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type("Footstepper", "Node3D", preload("./footstepper.gd"), preload("./footstepper_icon.svg"))


func _exit_tree() -> void:
	remove_custom_type("Footstepper")

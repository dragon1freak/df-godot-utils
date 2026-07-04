@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type("Footstepper", "Node3D", preload("./footstepper.gd"), preload("./footstepper_icon.svg"))
	add_custom_type("FootstepperTag", "Node3D", preload("./footstepper_tag.gd"), preload("./footstepper_tag_icon.svg"))


func _exit_tree() -> void:
	remove_custom_type("Footstepper")
	remove_custom_type("FootstepperTag")

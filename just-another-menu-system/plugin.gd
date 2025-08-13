@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type("MenuRouter", "Control", preload("./menu_router.gd"), preload("./menu_router_icon.svg"))
	add_custom_type("MenuContainer", "Control", preload("./menu_container.gd"), preload("./menu_container_icon.svg"))


func _exit_tree() -> void:
	remove_custom_type("MenuRouter")
	remove_custom_type("MenuContainer")

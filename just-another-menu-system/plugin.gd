@tool
extends EditorPlugin


func _enter_tree() -> void:	
	add_custom_type("MenuRouter", "Control", preload("./menu_router.gd"), null)
	add_custom_type("MenuContainer", "Control", preload("./menu_container.gd"), null)

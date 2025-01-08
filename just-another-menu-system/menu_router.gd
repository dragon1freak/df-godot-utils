extends Control

## Dictionary holding all registered menus
var MENUS : Dictionary = {}

## Menu history
var MENU_STACK : Array[MenuContainer] = []

## Currently open menus, is usually just one
var OPEN_MENUS : Array[MenuContainer] = []


func _ready() -> void:
	register_children()


## Finds and registers all MenuContainer child nodes
func register_children() -> void:
	var menu_children = self.find_children("", "MenuContainer", true)
	for child in menu_children:
		MENUS[child.name.to_lower()] = child
		child.close()


## Registers the passed node with the Menu Router
## If overwrite is true, it will overwrite an existing menu of the same name
## If overwrite is false, the new menu will not be registered if one already exists with that name
func register_menu(menu_node, overwrite := true) -> void:
	if overwrite or MENUS.get(menu_node.name.to_lower()) == null:
		MENUS[menu_node.name.to_lower()] = menu_node


## Clears all registered menus
func clear_registered_menus() -> void:
	MENUS = {}


func go_back() -> void:
	var current_menu = MENU_STACK.pop_back()
	var current_open_menu = OPEN_MENUS.pop_back()
	
	if current_menu != null:
		current_menu.close()
	if current_open_menu != null:
		current_open_menu.close()
	
	if MENU_STACK.size() <= 0:
		return
	
	var next_menu = MENU_STACK.back()
	if next_menu != null:
		next_menu.open()


func open_menu(menu_key : String, close_last_menu := true, on_open_callback : Callable = func(): pass) -> void:
	var target_menu = MENUS.get(menu_key.to_lower())
	if target_menu == null or target_menu == get_last_menu():
		return
	
	if close_last_menu:
		var last_menu = OPEN_MENUS.pop_back()
		if last_menu != null:
			last_menu.close()
	
	target_menu.open()
	MENU_STACK.push_back(target_menu)
	OPEN_MENUS.push_back(target_menu)
	
	on_open_callback.call()


func get_last_menu() -> MenuContainer:
	return MENU_STACK.back() if MENU_STACK.size() > 0 else null

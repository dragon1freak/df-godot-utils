extends Control

## Dictionary holding all registered menus
var MENUS : Dictionary = {}

## Menu history
var MENU_STACK : Array[MenuContainer] = []

## Currently open menus, is usually just one
var OPEN_MENUS : Array[MenuContainer] = []


func _ready() -> void:
	register_children()
	mouse_filter = MouseFilter.MOUSE_FILTER_IGNORE


## Finds and registers all MenuContainer child nodes
func register_children() -> void:
	var menu_children = self.find_children("", "MenuContainer", true)
	for child in menu_children:
		MENUS[child.name.to_lower()] = child
		if child.start_open:
			open_menu(child.name)
		else:
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


## Open the menu with the passed key
## [on_open_callback] is called after opening the target menu, if it exists
func open_menu(menu_key : String, on_open_callback : Callable = func(): pass) -> void:
	var target_menu = MENUS.get(menu_key.to_lower())
	if target_menu == null or target_menu == get_last_menu():
		return
	
	close_last_menu()
	
	target_menu.open()
	MENU_STACK.push_back(target_menu)
	OPEN_MENUS.push_back(target_menu)
	
	on_open_callback.call()


## Close the menu with the passed key
## [on_close_callback] is called after closing the target menu, if it exists
func close_menu(menu_key : String, open_previous_menu := true, on_close_callback : Callable = func(): pass) -> void:
	var target_menu = MENUS.get(menu_key.to_lower())
	if target_menu == null or not target_menu.is_open:
		return
	
	var menu_index = OPEN_MENUS.find(target_menu)
	if menu_index < 0:
		return
	
	close_last_menu(true)
	
	if open_previous_menu and MENU_STACK.size() > 0:
		var next_menu = MENU_STACK.back()
		if next_menu != null:
			next_menu.open()
			OPEN_MENUS.push_back(next_menu)
	
	on_close_callback.call()


## Close all other menus, clear menu history, open the menu with the passed key
func go_to(menu_key : String) -> void:
	close_all_menus()
	open_menu(menu_key)


## Go back one step in the menu history, closing the current menu
func go_back(open_next := true) -> void:
	close_menu(OPEN_MENUS.back().name, open_next)


## Get the most recent menu in the stack
func get_last_menu() -> MenuContainer:
	return MENU_STACK.back() if MENU_STACK.size() > 0 else null


## Close most recent menu
## [remove_from_stack] if true, also removes the most recent menu from the stack
func close_last_menu(remove_from_stack := false) -> void:
	var last_menu = OPEN_MENUS.pop_back()
	if last_menu != null:
		last_menu.close()
	if remove_from_stack:
		MENU_STACK.pop_back()


func close_all_menus() -> void:
	for menu in OPEN_MENUS:
		menu.close()
	OPEN_MENUS = []
	MENU_STACK = []

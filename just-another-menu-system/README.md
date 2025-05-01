# Just Another Menu System

JAMS is an easy way to manage your game's menu states. Currently it supports one open menu at a time which should work for most use cases. The MenuRouter and MenuContainer nodes are extensions of the control node and have no other affect on the layout of your menus allowing you to style them as needed. By calling methods on the MenuRouter node, you can easily open, close, or go to menus with just their name, case insensitive.

The MenuContainer node is also easily extended, so you can implement animations or other functionality on open or close.

## Instructions

### Installation:

Drop the <code>just-another-menu-system</code> folder into your project's <code>addons</code> folder and enable the <code>Just Another Menu System</code> plugin in your project settings.

<br>

### Usage

JAMS currently comes with two nodes, a `MenuRouter` and a `MenuContainer`.  Add a `MenuRouter`, then add `MenuContainers` as children of your router and name the nodes whatever you want, but be aware that name will be used as the menu's key.  Then simply call `open_menu` on your router and pass the name of the menu you want to open, thats it!  Using Godots advanced signal panel, you can wire up the buttons in your menus to call the different functions on the router directly, meaning you dont need any extra code to open and close your menus!  Read more about the different nodes below.

**MenuRouter**

`MenuRouter` is the brain of the system. On `ready`, it finds all existing `MenuContainer` children and registers them in its internal `MENUS` object, closing them unless set to `start_open`. It also holds a history stack of opened menus so you can very easily go back one or more steps no matter how deeply nested your menu is.

| Method                                                                                                       | Description                                                                                                                                                                                               |
| ------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| clear_registered_menus()                                                                                     | Clears all registered menus                                                                                                                                                                               |
| close_all_menus()                                                                                            | Closes all open menus and clears the history stack                                                                                                                                                        |
| close_last_menu(remove_from_stack : bool = false)                                                            | Close the most recent menu. If `remove_from_stack` is true, also removes it from the menu history stack                                                                                                   |
| close_menu(menu_key : String, open_previous_menu : bool = true, on_close_callback : Callable = func(): pass) | Closes the menu registered with the passed key. If `open_previous_menu` is true, the previous menu in the stack is open, if it exists. `on_close_callback` is called after closing the menu, if it exists |
| get_last_menu()                                                                                              | Returns the most recent menu in the stack, if it exists                                                                                                                                                   |
| go_back(open_next : bool = true)                                                                             | Go back one step in the menu history, closing the current menu. If `open_next` is true, opens the previous menu in the stack                                                                              |
| go_to(menu_key : String)                                                                                     | Closes all other menus, clears the menu history, and opens the menu registered with the passed key.                                                                                                       |
| open_menu(menu_key : String, on_open_callback : Callable = func(): pass)                                     | Opens the menu registered with the passed key. `on_open_callback` is called after opening the menu, if it exists                                                                                          |
| register_children()                                                                                          | Finds and registers all MenuContainer child nodes                                                                                                                                                         |
| register_menu(menu_node : MenuContainer, overwrite : bool = true)                                            | Registers the passed MenuContainer with the MenuRouter. If `overwrite` is true, overwrites any previously registered menu of the same name                                                                |

**MenuContainer**

`MenuContainer` is what holds your menus and is controlled by the `MenuRouter`. When being open or closed, the related `on_open()` and `on_close()` methods are called. By default, the visibility is toggled, but you can easily extend the node and override these methods for your own functionality such as triggering animations.

Currently it is **NOT** suggested to nest `MenuContainer` nodes, since only one menu can be open at a time, so the parent menu will be closed, hiding the child menu. You could override the previously mentioned methods and implement this yourself though.

| Method     | Description                 |
| ---------- | --------------------------- |
| on_open()  | Called when the menu opens  |
| on_close() | Called when the menu closes |
